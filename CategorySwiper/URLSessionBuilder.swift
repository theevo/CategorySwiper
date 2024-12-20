//
//  URLSessionBuilder.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/29/24.
//

import Foundation

struct URLSessionBuilder {
    var bearerToken: String
    
    init() {
        self.bearerToken = ProcessInfo.processInfo.environment["LUNCHMONEY_ACCESS_TOKEN"] ?? ""
    }
    
    init(bearerToken: String) {
        self.bearerToken = bearerToken
    }
    
    func getCategories() async -> Result<Response, SessionError> {
        guard let request = LMNetworkInterface.LunchMoneyURL.GetCategories.makeRequest() else { return .failure(.BadURL) }
        
        print(request)
        return await lunchMoneyURLSession(request: request)
    }
    
    func getTransactions(filters: [Filter] = []) async -> Result<Response, SessionError> {
        guard let request = LMNetworkInterface.LunchMoneyURL.GetTransactions.makeRequest(filters: filters) else { return .failure(.BadURL) }

        return await lunchMoneyURLSession(request: request)
    }
    
    /// Update Transaction Status
    /// - Parameters:
    ///   - transaction: the `Transaction` to be updated
    ///   - newStatus: what `Transaction.Status` you want it to be
    /// - Returns: true if the transaction was updated successfully
    func update(transaction: Transaction, newStatus: Transaction.Status) async -> Result<Response, URLSessionBuilder.SessionError> {
        guard let putRequest = LMNetworkInterface.LunchMoneyURL.UpdateTransaction(transaction: transaction, newStatus: newStatus).makeRequest() else { return .failure(.BadURL) }
        
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
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    return .failure(.HTTPStatusCode(response: httpResponse))
                }
            } else {
                return .failure(.NoHTTPResponse(urlResponse: urlResponse))
            }
            
            return .success(Response(data: data, urlResponse: urlResponse))
        } catch {
            return .failure(.SessionFailed(details: ErrorDetails(file: #file, function: #function, line: #line, error: error)))
        }
    }
}

extension URLSessionBuilder {
    struct Response {
        var data: Data
        var urlResponse: URLResponse
    }
    
    enum SessionError: LocalizedError {
        case SessionFailed(details: ErrorDetails)
        case BadURL
        case HTTPStatusCode(response: HTTPURLResponse)
        case NoHTTPResponse(urlResponse: URLResponse)
        
        var errorDescription: String? {
            switch self {
            case .SessionFailed(let details):
                "Error: URLSession failure. Error: \(details)"
            case .BadURL:
                "Tried to create URL with URLComponents, but it was not successful."
            case .HTTPStatusCode(response: let response):
                "Server returned HTTP status code \(response.statusCode)."
            case .NoHTTPResponse(urlResponse: let response):
                "Unable to decode response. See raw response: \(response)"
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

struct ErrorDetails: CustomStringConvertible {
    var file: String
    var function: String
    var line: Int
    var error: Error
    
    var description: String {
        "\(file) \(function) line \(line): \(error.localizedDescription)"
    }
}
