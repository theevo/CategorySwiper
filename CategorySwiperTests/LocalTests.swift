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
        let object = try interface.getTransactions()
        XCTAssertTrue(object.transactions.notEmpty)
    }
    
    func test_TransactionsLoader_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async throws {
        let interface = LMLocalInterface()
        let object = try interface.getTransactions(showUnclearedOnly: true)
        XCTAssertEqual(object.transactions.count, object.uncleared.count)
    }
    
    func test_LocalTransactionsLoader_request5_get5Transactions() async throws {
        let interface = LMLocalInterface()
        let transactions = try interface.loadTransactions(limit: 5)
        XCTAssertEqual(transactions.count, 5)
    }
    
    func test_InterfaceManager_getCategories_returnsNonEmptyCategoriesArray() async {
        let manager = InterfaceManager(localMode: true)
        
        do {
            try await manager.getCategories()
            XCTAssertTrue(manager.categories.notEmpty)
            
            let category = manager.categories.first {
                $0.name.contains("Apple")
            }
            XCTAssertEqual(category?.name, "Apples")
        } catch {
            XCTFail("Error: \(#function) returned this error: \(error)")
        }
    }
}
