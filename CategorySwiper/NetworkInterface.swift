//
//  NetworkInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/29/24.
//

import Foundation

struct NetworkInterface {
    var bearerToken: String
    
    init() {
        self.bearerToken = ProcessInfo.processInfo.environment["LUNCHMONEY_ACCESS_TOKEN"] ?? ""
    }
    
    init(bearerToken: String) {
        self.bearerToken = bearerToken
    }
    
    func getTransactions(filters: [Filter] = []) async -> Result<Response, SessionError> {
        guard let request = LunchMoneyURL.GetTransactions.makeRequest(filters: filters) else { return .failure(.BadURL) }

        return await lunchMoneyURLSession(request: request)
    }
    
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Result<Response, NetworkInterface.SessionError> {
        guard let putRequest = LunchMoneyURL.UpdateTransaction(transaction: transaction, newStatus: newStatus).makeRequest() else { return .failure(.BadURL) }
        
        return await lunchMoneyURLSession(request: putRequest)
    }
    
    private func lunchMoneyURLSession(request: URLRequest) async -> Result<Response, SessionError> {
        let sessionConfiguration = URLSessionConfiguration.default // 5

        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(bearerToken)" // 6
        ]

        let session = URLSession(configuration: sessionConfiguration) // 7
        
        do {
            let (data, urlResponse) = try await session.data(for: request)
            return .success(Response(data: data, urlResponse: urlResponse))
        } catch {
            return .failure(.SessionFailed(details: ErrorDetails(file: #file, function: #function, line: #line, error: error)))
        }
    }
    
    enum Filter: String {
        case Uncleared
        
        var queryItem: URLQueryItem {
            switch self {
            case .Uncleared:
                URLQueryItem(name: "status", value: Transaction.unclearedStatus)
            }
        }
    }
    
    enum LunchMoneyURL {
        case GetTransactions
        case UpdateTransaction(transaction: Transaction, newStatus: Transaction.Status)
        
        private var baseURL: URL? {
            switch self {
            case .GetTransactions:
                URL(string: endpoint)
            case .UpdateTransaction(transaction: let transaction, newStatus: _):
                LunchMoneyURL.GetTransactions.baseURL?.appending(path: String(transaction.id))
            }
        }
        
        private var endpoint: String {
            switch self {
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

extension NetworkInterface {
    struct Response {
        var data: Data
        var urlResponse: URLResponse
    }
    
    enum SessionError: LocalizedError {
        case SessionFailed(details: ErrorDetails)
        case BadURL
        
        var errorDescription: String? {
            switch self {
            case .SessionFailed(let details):
                "Error: URLSession failure. Error: \(details)"
            case .BadURL:
                "Tried to create URL with URLComponents, but it was not successful."
            }
        }
    }
}

struct PutBodyObject: Encodable {
    var transaction: UpdateTransactionObject
    
    init(transaction: Transaction, newStatus: Transaction.Status) {
        self.transaction = UpdateTransactionObject(transaction: transaction, newStatus: newStatus)
    }
}

struct UpdateTransactionObject: Encodable {
    var id: Int
    var status: String
    
    init(transaction: Transaction, newStatus: Transaction.Status) {
        self.id = transaction.id
        self.status = newStatus.rawValue
    }
}

struct ErrorDetails: CustomStringConvertible {
    var file: String
    var function: String
    var line: Int
    var error: Error
    
    var description: String {
        "\(file) \(function) line \(line): \(error.localizedDescription)"
    }
}
