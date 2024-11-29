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
