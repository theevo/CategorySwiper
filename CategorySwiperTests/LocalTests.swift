//
//  LocalTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 11/5/24.
//

import XCTest
@testable import CategorySwiper

final class LocalTests: XCTestCase {
    
    func test_TransactionsLoader_returns_nonEmptyTransactionsArray_andStatusCode200() async throws {
        let interface = LMLocalInterface()
        let (object, statusCode) = try interface.getTransactions()
        XCTAssertTrue(object.transactions.notEmpty)
        XCTAssertEqual(statusCode, 200)
    }
    
    func test_TransactionsLoader_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async throws {
        let interface = LMLocalInterface()
        let (object, statusCode) = try interface.getTransactions(showUnclearedOnly: true)
        XCTAssertEqual(object.transactions.count, object.uncleared.count)
        XCTAssertEqual(statusCode, 200)
    }
    
    func test_LocalTransactionsLoader_request5_get5Transactions() async throws {
        let interface = LMLocalInterface()
        let transactions = try interface.loadTransactions(limit: 5)
        XCTAssertEqual(transactions.count, 5)
    }
}
