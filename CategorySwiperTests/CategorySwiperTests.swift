//
//  CategorySwiperTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 11/5/24.
//

import XCTest
@testable import CategorySwiper

final class CategorySwiperTests: XCTestCase {
    
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
    
    func test_TransactionsLoader_returns_nonEmptyTransactionsArray_andStatusCode200() async throws {
        let loader = LocalTransactionsLoader()
        let (object, statusCode) = try loader.load()
        XCTAssertTrue(object.transactions.notEmpty)
        XCTAssertEqual(statusCode, 200)
    }
    
    func test_TransactionsLoader_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async throws {
        let loader = LocalTransactionsLoader()
        let (object, statusCode) = try loader.load(showUnclearedOnly: true)
        XCTAssertEqual(object.transactions.count, object.uncleared.count)
        XCTAssertEqual(statusCode, 200)
    }
    
    func test_LocalTransactionsLoader_request5_get5Transactions() async throws {
        let loader = LocalTransactionsLoader()
        let transactions = try loader.loadTransactions(limit: 5)
        XCTAssertEqual(transactions.count, 5)
    }
}
