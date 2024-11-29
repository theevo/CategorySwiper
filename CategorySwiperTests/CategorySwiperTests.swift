//
//  CategorySwiperTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 11/5/24.
//

import XCTest
@testable import CategorySwiper

final class CategorySwiperTests: XCTestCase {
    
    func test_apiCall_with_INVALID_BearerToken_resultsIn_401statusCode() async {
        let key = "junktoken"
        
        let interface = NetworkInterface(bearerToken: key)
        
        let result = await interface.getCategories()
        
        guard case .success(let response) = result else {
            XCTFail("URLSession failed")
            return
        }
        
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 401)
        }
    }
    
    func test_apiCall_with_VALID_BearerToken_resultsIn_200statusCode_andNoError() async {
        let interface = NetworkInterface()
        
        let result = await interface.getCategories()
        
        guard case .success(let response) = result else {
            XCTFail("URLSession failed")
            return
        }
        
        // check for status 200
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 200)
        }
        
        // check data for Error
        guard let data = response.data else {
            XCTFail("failed to unwrap data")
            return
        }
        
        let dataString = String(data: data, encoding: .utf8) ?? "Unknown"
        print(dataString)
        XCTAssertFalse(dataString.contains("\"name\":\"Error\""))
    }
}

struct NetworkInterface {
    var bearerToken: String
    
    init() {
        self.bearerToken = ProcessInfo.processInfo.environment["LUNCHMONEY_ACCESS_TOKEN"] ?? ""
    }
    
    init(bearerToken: String) {
        self.bearerToken = bearerToken
    }
    
    func getCategories() async -> Result<Response, SessionError> {
        let transactionsURL = URL( // 1
            string: "https://dev.lunchmoney.app/v1/transactions"
        )!
        var request = URLRequest( // 2
            url: transactionsURL
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
        }
        return .failure(.SessionFailed)
    }
}

extension NetworkInterface {
    struct Response {
        var data: Data?
        var urlResponse: URLResponse?
    }
    
    enum SessionError: LocalizedError {
        case SessionFailed
        
        var errorDescription: String? {
            switch self {
            case .SessionFailed:
                "Tried to establish URLSession data session, but it was not successful."
            }
        }
    }
}
