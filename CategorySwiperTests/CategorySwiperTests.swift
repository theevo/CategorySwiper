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
        
        let (_, response) = await interface.getCategories()
        
        if let httpResponse = response as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 401)
        }
    }
    
    func test_apiCall_with_VALID_BearerToken_resultsIn_200statusCode_andNoError() async {
        let interface = NetworkInterface()
        
        let (data, response) = await interface.getCategories()
        
        // check for status 200
        if let httpResponse = response as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 200)
        }
        
        // check data for Error
        guard let data = data else {
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
    
    func getCategories() async -> (Data?, URLResponse?) {
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
            return try await session.data(for: request)
        } catch {
            print("\(#file) \(#function) line \(#line): URLSession failed")
        }
        return (nil, nil)
    }
}
