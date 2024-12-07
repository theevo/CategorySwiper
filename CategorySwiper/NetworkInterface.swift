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
        let transactionsURL = URL( // 1
            string: "https://dev.lunchmoney.app/v1/transactions"
        )!
        
        var queries: [URLQueryItem] = []
        
        for filter in filters {
            queries.append(filter.queryItem)
        }
        
        var urlComponents = URLComponents(url: transactionsURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queries
        
        guard let finalURL = urlComponents?.url else { return .failure(.BadURL) }
        
        var request = URLRequest(
            url: finalURL
        )
        request.setValue( // 3
            "Bearer <<access-token>>",
            forHTTPHeaderField: "Authentication"
        )
        request.setValue( // 4
            "application/json;charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )

        let sessionConfiguration = URLSessionConfiguration.default // 5

        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(bearerToken)" // 6
        ]

        let session = URLSession(configuration: sessionConfiguration) // 7
        
        do {
            let (data, urlResponse) = try await session.data(for: request)
            return .success(Response(data: data, urlResponse: urlResponse))
        } catch {
            print("\(#file) \(#function) line \(#line): URLSession failed")
            print("error: \(error)")
        }
        return .failure(.SessionFailed)
    }
    
    func update(transaction: Transaction, status: Transaction.Status) async throws -> Result<Response, NetworkInterface.SessionError> {
        
        var transactionsURL = URL( // 1
            string: "https://dev.lunchmoney.app/v1/transactions"
        )!
        
        // transaction ID Appending Path
        transactionsURL.append(path: String(transaction.id))
        
        var urlComponents = URLComponents(url: transactionsURL, resolvingAgainstBaseURL: true)
        
        guard let finalURL = urlComponents?.url else { return .failure(.BadURL) }
        
        var request = URLRequest(
            url: finalURL
        )
        request.httpMethod = "PUT"
        request.setValue( // 3
            "Bearer <<access-token>>",
            forHTTPHeaderField: "Authentication"
        )
        request.setValue( // 4
            "application/json;charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        
        let putBody = PutBodyObject(transaction: transaction, newStatus: status)
        let data = try JSONEncoder().encode(putBody)
        request.httpBody = data
        
        let sessionConfiguration = URLSessionConfiguration.default // 5

        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(bearerToken)" // 6
        ]

        let session = URLSession(configuration: sessionConfiguration) // 7
        
        do {
            let (data, urlResponse) = try await session.data(for: request)
            return .success(Response(data: data, urlResponse: urlResponse))
        } catch {
            print("\(#file) \(#function) line \(#line): URLSession failed")
            print("error: \(error)")
        }
        
        return .failure(.SessionFailed)
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
}

extension NetworkInterface {
    struct Response {
        var data: Data?
        var urlResponse: URLResponse?
    }
    
    enum SessionError: LocalizedError {
        case SessionFailed
        case BadURL
        
        var errorDescription: String? {
            switch self {
            case .SessionFailed:
                "Tried to establish URLSession data session, but it was not successful."
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
