//
//  LMNetworkInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/20/24.
//

import Foundation

struct LMNetworkInterface: LunchMoneyInterface {
    func getCategories() async throws -> CategoryResponseWrapper {
        let builder = makeURLSessionBuilder()
        let request = Request.GetCategories.makeRequest()
        let result = await builder.execute(request: request)
        
        switch result {
        case .success(let response):
            do {
                let object = try JSONDecoder().decode(CategoryResponseWrapper.self, from: response.data)
                return object
            } catch (let error) {
                throw LoaderError.JSONFailure(error: error)
            }
        case .failure(let error):
            throw LoaderError.SessionErrorThrown(error: error)
        }
    }
    
    fileprivate func transactionQueryParams(_ showUnclearedOnly: Bool, _ monthsAgo: UInt?) -> [LMQueryParams.Transactions] {
        var queryParams: [LMQueryParams.Transactions] = []
        
        if showUnclearedOnly {
            queryParams.append(.Uncleared)
        }
        
        if let monthsAgo = monthsAgo {
            let monthRange = MonthRangeBuilder(monthsAgo: monthsAgo)
            queryParams.append(.DateRange(startDate: monthRange.first, endDate: monthRange.last))
        }
        
        return queryParams
    }
    
    func getTransactions(showUnclearedOnly: Bool = false, monthsAgo: UInt? = nil) async throws -> TransactionsResponseWrapper {
        let builder = makeURLSessionBuilder()
        
        let queryParams = transactionQueryParams(showUnclearedOnly, monthsAgo)
        
        let request = Request.GetTransactions.makeRequest(filters: queryParams)
        
        let result = await builder.execute(request: request)
        
        switch result {
        case .success(let response):
            do {
                let object = try JSONDecoder().decode(TransactionsResponseWrapper.self, from: response.data)
                return object
            } catch (let error) {
                throw LoaderError.JSONFailure(error: error)
            }
        case .failure(let error):
            throw LoaderError.SessionErrorThrown(error: error)
        }
    }
    
    func update(transaction: Transaction, newCategory: Category) async throws -> Bool {
        guard transaction.category_id != newCategory.id else { return false }
        
        let request = Request.UpdateTransactionCategory(transaction: transaction, newCategory: newCategory).makeRequest()
        
        let builder = makeURLSessionBuilder()
        
        let result = await builder.execute(request: request)
        
        switch result {
        case .success(let response):
            do {
                let object = try JSONDecoder().decode(UpdateTransactionResponseObject.self, from: response.data)
                return object.updated
            } catch (let error) {
                throw LoaderError.JSONFailure(error: error)
            }
        case .failure(let error):
            throw LoaderError.SessionErrorThrown(error: error)
        }
    }
    
    func clear(transaction: Transaction) async throws -> Bool {
        let request = Request.UpdateTransactionStatus(transaction: transaction, newStatus: .cleared).makeRequest()
        
        let builder = makeURLSessionBuilder()
        
        let result = await builder.execute(request: request)
        
        switch result {
        case .success(let response):
            do {
                let object = try JSONDecoder().decode(UpdateTransactionResponseObject.self, from: response.data)
                return object.updated
            } catch (let error) {
                throw LoaderError.JSONFailure(error: error)
            }
        case .failure(let error):
            throw LoaderError.SessionErrorThrown(error: error)
        }
    }
    
    enum Request {
        case GetCategories
        case GetTransactions
        case UpdateTransactionStatus(transaction: Transaction, newStatus: Transaction.Status)
        case UpdateTransactionCategory(transaction: Transaction, newCategory: Category)
        
        private var baseURL: URL? {
            switch self {
            case .GetCategories:
                URL(string: endpoint)
            case .GetTransactions:
                URL(string: endpoint)
            case .UpdateTransactionStatus(transaction: let transaction, newStatus: _), .UpdateTransactionCategory(transaction: let transaction, newCategory: _):
                Request.GetTransactions.baseURL?.appending(path: String(transaction.id))
            }
        }
        
        private var endpoint: String {
            switch self {
            case .GetCategories:
                "https://dev.lunchmoney.app/v1/categories"
            case .GetTransactions, .UpdateTransactionStatus(_, _), .UpdateTransactionCategory(_, _):
                "https://dev.lunchmoney.app/v1/transactions"
            }
        }
        
        private var urlComponents: URLComponents? {
            guard let baseURL else { return nil }
            return URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        }
        
        private func queryItems(filters: [QueryItemBuilder]) -> [URLQueryItem] {
            filters.flatMap { $0.queryItems }
        }
        
        func makeRequest(filters: [QueryItemBuilder] = []) -> URLRequest? {
            switch self {
            case .GetCategories:
                return baseRequest(filters: [LMQueryParams.Categories.FormatIsNested])
            case .GetTransactions:
                return baseRequest(filters: filters)
            case .UpdateTransactionStatus(_, _), .UpdateTransactionCategory(_, _):
                var baseRequest = baseRequest(filters: filters)
                baseRequest = try? newPutRequest(baseRequest: baseRequest)
                return baseRequest
            }
        }
        
        private func baseRequest(filters: [QueryItemBuilder] = []) -> URLRequest? {
            var components = urlComponents
            components?.queryItems = queryItems(filters: filters)
            guard let url = components?.url else { return nil }
            
            var request = URLRequest(
                url: url
            )
            request.setValue(
                "Bearer <<access-token>>",
                forHTTPHeaderField: "Authentication"
            )
            request.setValue(
                "application/json;charset=utf-8",
                forHTTPHeaderField: "Content-Type"
            )
            return request
        }
        
        private func newPutRequest(baseRequest request: URLRequest?) throws -> URLRequest? {
            guard var request = request else { return nil }
            
            var putBody: PutBodyObject
            
            switch self {
            case .UpdateTransactionStatus(let transaction, let status):
                putBody = PutBodyObject(transaction: transaction, newStatus: status)
            case .UpdateTransactionCategory(let transaction, let category):
                putBody = PutBodyObject(transaction: transaction, newCategory: category)
            default:
                return nil
            }
            
            let data = try JSONEncoder().encode(putBody)
            
            request.httpMethod = "PUT"
            request.httpBody = data
            
            return request
        }
    }
}

protocol QueryItemBuilder {
    var queryItems: [URLQueryItem] { get }
}

/// It's a URLQueryItem builder.
enum LMQueryParams {
    enum Categories: QueryItemBuilder {
        case FormatIsNested
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .FormatIsNested:
                [URLQueryItem(name: "format", value: "nested")]
            }
        }
    }
    
    /// StartDate and EndDate require the format YYYY-MM-DD, and they must travel together.
    enum Transactions: QueryItemBuilder {
        case Uncleared
        case DateRange(startDate: String, endDate: String)
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .Uncleared:
                [URLQueryItem(name: "status", value: Transaction.unclearedStatus)]
            case .DateRange(let startDate, let endDate):
                [
                    URLQueryItem(name: "start_date", value: startDate),
                    URLQueryItem(name: "end_date", value: endDate)
                ]
            }
        }
    }
}

extension LMNetworkInterface {
    private func makeURLSessionBuilder() -> URLSessionBuilder {
        let bearerToken = ProcessInfo.processInfo.environment["LUNCHMONEY_ACCESS_TOKEN"] ?? ""
        return URLSessionBuilder(bearerToken: bearerToken)
    }
}

// MARK: - Codable Objects

struct PutBodyObject: Encodable {
    var transaction: UpdateTransactionObject
    
    init(transaction: Transaction, newStatus: Transaction.Status) {
        self.transaction = UpdateTransactionObject(transaction: transaction, newStatus: newStatus)
    }
    
    init(transaction: Transaction, newCategory: Category) {
        self.transaction = UpdateTransactionObject(transaction: transaction, newCategory: newCategory)
    }
}

struct UpdateTransactionResponseObject: Decodable {
    var updated: Bool
}

struct UpdateTransactionObject: Encodable {
    var id: Int
    var status: String?
    var category_id: Int?
    
    init(transaction: Transaction, newStatus: Transaction.Status) {
        self.id = transaction.id
        self.status = newStatus.rawValue
    }
    
    init(transaction: Transaction, newCategory: Category) {
        self.id = transaction.id
        self.category_id = newCategory.id
    }
}
