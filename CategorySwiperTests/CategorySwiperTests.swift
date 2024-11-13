//
//  CategorySwiperTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 11/5/24.
//

import XCTest
@testable import CategorySwiper

final class CategorySwiperTests: XCTestCase {
    
    func test_apiCall_withBearerToken() async {
        guard let key = ProcessInfo.processInfo.environment["LUNCHMONEY_ACCESS_TOKEN"] else {
            XCTFail("access key is not setup")
            return
        }
        
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
            "Authorization": "Bearer \(key)" // 6
        ]

        let session = URLSession(configuration: sessionConfiguration) // 7
        
        do {
            let (data, response) = try await session.data(for: request)
            //        print(String(data: data, encoding: .utf8) ?? "Unknown")
            XCTAssertFalse(data.isEmpty)
        } catch {
            XCTFail("Failed to make API call: \(error)")
        }
        // assert status code == 200 in the response
        
    }
}
