//
//  LMNetworkInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/20/24.
//

import Foundation

struct LMNetworkInterface: LunchMoneyInterface {
    func getTransactions(showUnclearedOnly: Bool = false) async throws -> (TopLevelObject, Int) {
        let builder = makeURLSessionBuilder()
        
        let filters = showUnclearedOnly ? [Filter.Uncleared] : []
        
        let request = Request.GetTransactions.makeRequest(filters: filters)
        
        let result = await builder.execute(request: request)
        
        switch result {
        case .success(let response):
            var object: TopLevelObject = TopLevelObject(transactions: [])
            var statusCode = 0
            
            if let httpResponse = response.urlResponse as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            do {
                object = try JSONDecoder().decode(TopLevelObject.self, from: response.data)
                return (object, statusCode)
            } catch (let error) {
                throw LoaderError.JSONFailure(error: error)
            }
        case .failure(let error):
            throw LoaderError.SessionErrorThrown(error: error)
        }
    }
    
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool {
        
        let request = Request.UpdateTransaction(transaction: transaction, newStatus: newStatus).makeRequest()
        
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
        case UpdateTransaction(transaction: Transaction, newStatus: Transaction.Status)
        
        private var baseURL: URL? {
            switch self {
            case .GetCategories:
                URL(string: endpoint)
            case .GetTransactions:
                URL(string: endpoint)
            case .UpdateTransaction(transaction: let transaction, newStatus: _):
                Request.GetTransactions.baseURL?.appending(path: String(transaction.id))
            }
        }
        
        private var endpoint: String {
            switch self {
            case .GetCategories:
                "https://dev.lunchmoney.app/v1/categories"
            case .GetTransactions, .UpdateTransaction(_, _):
                "https://dev.lunchmoney.app/v1/transactions"
            }
        }
        
        private var urlComponents: URLComponents? {
            guard let baseURL else { return nil }
            return URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        }
        
        private func queryItems(filters: [Filter]) -> [URLQueryItem] {
            filters.map { $0.queryItem }
        }
        
        func makeRequest(filters: [Filter] = []) -> URLRequest? {
            if case .GetCategories = self {
                return baseRequest(filters: [.CategoryFormatIsNested])
            }
            
            var baseRequest = baseRequest(filters: filters)
            
            if case .UpdateTransaction = self {
                baseRequest = try? newPutRequest(baseRequest: baseRequest)
            }
            
            return baseRequest
        }
        
        private func baseRequest(filters: [Filter] = []) -> URLRequest? {
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
            guard case .UpdateTransaction(let transaction, let status) = self,
                var request = request else {
                return nil
            }
            
            let putBody = PutBodyObject(transaction: transaction, newStatus: status)
            let data = try JSONEncoder().encode(putBody)
            
            request.httpMethod = "PUT"
            request.httpBody = data
            
            return request
        }
    }
}

enum Filter: String {
    case Uncleared
    case CategoryFormatIsNested // TODO: - this should only apply to GetAllCategories
    
    var queryItem: URLQueryItem {
        switch self {
        case .Uncleared:
            URLQueryItem(name: "status", value: Transaction.unclearedStatus)
        case .CategoryFormatIsNested:
            URLQueryItem(name: "format", value: "nested")
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
}

struct UpdateTransactionResponseObject: Decodable {
    var updated: Bool
}

struct UpdateTransactionObject: Encodable {
    var id: Int
    var status: String
    
    init(transaction: Transaction, newStatus: Transaction.Status) {
        self.id = transaction.id
        self.status = newStatus.rawValue
    }
}
