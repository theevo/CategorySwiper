//
//  NetworkTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 12/6/24.
//

import XCTest
@testable import CategorySwiper

final class NetworkTests: XCTestCase {

    func test_NetworkInterace_with_INVALID_BearerToken_resultsIn_401statusCode() async {
        let key = "junktoken"
        
        let interface = NetworkInterface(bearerToken: key)
        
        let result = await interface.getTransactions()
        
        guard case .success(let response) = result else {
            XCTFail("URLSession failed")
            return
        }
        
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 401)
        }
    }

}
