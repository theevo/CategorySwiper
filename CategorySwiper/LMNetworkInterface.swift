//
//  LMNetworkInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/20/24.
//

import Foundation

struct LMNetworkInterface: LunchMoneyInterface {
    private let _bearerToken: String
    
    init() {
        do {
            self._bearerToken = try SecretsStash().recall(key: "LunchMoneyBearerToken")
        } catch {
            self._bearerToken = ""
            LogThisAs.state("Error: Access Token could not be found in Keychain. Details: \(error.localizedDescription)")
        }
    }
    
    var bearerToken: String {
        _bearerToken.notEmpty ? "A_TOKEN_EXISTS" : ""
    }
    
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
    
    func isBearerTokenValid() async -> Bool {
        guard _bearerToken.notEmpty else {
            return false
        }
        
        do {
            let _ = try await getCategories()
            return true
        } catch {
            LogThisAs.state("\(#function) threw error: \(error.localizedDescription)")
            return false
        }
    }
    
    fileprivate func transactionQueryParams(_ showUnclearedOnly: Bool, _ monthsAgo: UInt?, _ inLastMonths: UInt? = nil) -> [LMQueryParams.Transactions] {
        var queryParams: [LMQueryParams.Transactions] = []
        
        if showUnclearedOnly {
            queryParams.append(.Uncleared)
        }
        
        if let monthsAgo = monthsAgo {
            let monthRange = MonthRangeBuilder(monthsAgo: monthsAgo)
            queryParams.append(.DateRange(startDate: monthRange.first, endDate: monthRange.last))
        }
        
        if let inLastMonths = inLastMonths {
            let monthRange = MonthRangeBuilder(precedingMonthsBeforeThisMonth: inLastMonths)
            queryParams.append(.DateRange(startDate: monthRange.first, endDate: monthRange.last))
        }
        
        return queryParams
    }
    
    func findOldestUnclearedTransaction(withinPrecedingMonths: UInt = 12) async throws -> Transaction? {
        let response = try await getTransactions(showUnclearedOnly: true, withinPrecedingMonths: withinPrecedingMonths)
        
        guard response.transactions.notEmpty else {
            return nil
        }
        
        return response.transactions.first
    }
    
    func getUnclearedTransactions(withinPrecedingMonths: UInt?) async throws -> TransactionsResponseWrapper {
        return try await getTransactions(showUnclearedOnly: true, withinPrecedingMonths: withinPrecedingMonths)
    }
    
    func getTransactions(showUnclearedOnly: Bool = false, monthsAgo: UInt? = nil, withinPrecedingMonths: UInt? = nil) async throws -> TransactionsResponseWrapper {
        let builder = makeURLSessionBuilder()
        
        let queryParams = transactionQueryParams(showUnclearedOnly, monthsAgo, withinPrecedingMonths)
        
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
    
    func removeBearerToken() {
        do {
            try SecretsStash().delete(key: "LunchMoneyBearerToken")
        } catch {
            LogThisAs.state("Info: Access Token could not be deleted from Keychain. Details: \(error.localizedDescription)")
        }
    }
    
    func saveBearerToken(_ token: String) {
        guard token.notEmpty else {
            return
        }
        
        do {
            try SecretsStash().save(key: "LunchMoneyBearerToken", value: token)
        } catch {
            LogThisAs.state("Error: Access Token could not be saved in Keychain. Details: \(error.localizedDescription)")
        }
    }
    
    func updateAndClear(transaction: Transaction, newCategory: Category?) async throws -> Bool {
        guard let newCategory = newCategory,
              transaction.category_id != newCategory.id else { return false }
        
        let request = Request.UpdateCategoryAndClearStatus(transaction: transaction, newCategory: newCategory).makeRequest()
        
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
        let request = Request.ClearStatus(transaction: transaction).makeRequest()
        
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
        case ClearStatus(transaction: Transaction)
        case UpdateCategoryAndClearStatus(transaction: Transaction, newCategory: Category)
        
        private var baseURL: URL? {
            switch self {
            case .GetCategories:
                URL(string: endpoint)
            case .GetTransactions:
                URL(string: endpoint)
            case .ClearStatus(transaction: let transaction), .UpdateCategoryAndClearStatus(transaction: let transaction, newCategory: _):
                Request.GetTransactions.baseURL?.appending(path: String(transaction.id))
            }
        }
        
        private var endpoint: String {
            switch self {
            case .GetCategories:
                "https://dev.lunchmoney.app/v1/categories"
            case .GetTransactions, .ClearStatus(_), .UpdateCategoryAndClearStatus(_, _):
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
            case .ClearStatus(_), .UpdateCategoryAndClearStatus(_, _):
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
            case .ClearStatus(let transaction):
                putBody = PutBodyObject(transaction: transaction)
            case .UpdateCategoryAndClearStatus(let transaction, let category):
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
        case Limit(Int)
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .Uncleared:
                [URLQueryItem(name: "status", value: Transaction.unclearedStatus)]
            case .DateRange(let startDate, let endDate):
                [
                    URLQueryItem(name: "start_date", value: startDate),
                    URLQueryItem(name: "end_date", value: endDate)
                ]
            case .Limit(let limit):
                [URLQueryItem(name: "limit", value: String(limit))]
            }
        }
    }
}

extension LMNetworkInterface {
    private func makeURLSessionBuilder() -> URLSessionBuilder {
        return URLSessionBuilder(bearerToken: _bearerToken)
    }
}

// MARK: - Codable Objects

struct PutBodyObject: Encodable {
    var transaction: UpdateTransactionObject
    
    init(transaction: Transaction, newCategory: Category? = nil, status: Transaction.Status = .cleared) {
        self.transaction = UpdateTransactionObject(transaction: transaction, newCategory: newCategory, status: status)
    }
}

struct UpdateTransactionResponseObject: Decodable {
    var updated: Bool
}

struct UpdateTransactionObject: Encodable {
    var id: Int
    var status: String?
    var category_id: Int?
    
    init(transaction: Transaction, newCategory: Category?, status: Transaction.Status) {
        self.id = transaction.id
        self.status = status.rawValue
        self.category_id = newCategory?.id
    }
}
