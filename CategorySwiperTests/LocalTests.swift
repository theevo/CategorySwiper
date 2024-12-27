//
//  LocalTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 11/5/24.
//

import XCTest
@testable import CategorySwiper

final class LocalTests: XCTestCase {
    
    func test_InterfaceManager_returns_nonEmptyTransactionsArray() async throws {
        let manager = InterfaceManager(localMode: true)
        try await manager.getTransactions()
        XCTAssertTrue(manager.transactions.notEmpty)
    }
    
    func test_InterfaceManager_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async throws {
        let manager = InterfaceManager(localMode: true)
        try await manager.getTransactions(showUnclearedOnly: true)
        XCTAssertEqual(manager.transactions.count, manager.uncleared.count)
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
    
    func test_InterfaceManager_updateTransactionCategory_whenNewCategoryIsDifferent_returnsTrue() async {
        let manager = InterfaceManager(localMode: true)
        let transaction = Transaction.exampleCentralMarket
        
        do {
            let result = try await manager.update(transaction: transaction, newCategory: Category.exampleMusic)
            XCTAssertTrue(result)
        } catch {
            XCTFail("Error: \(#function) returned this error: \(error)")
        }
    }
    
    func test_InterfaceManager_updateTransactionCategory_whenNewCategoryIsSame_returnsFalse() async throws {
        let manager = InterfaceManager(localMode: true)
        let transaction = Transaction.exampleCentralMarket
        
        let result = try await manager.update(transaction: transaction, newCategory: Category.exampleGas)
        XCTAssertFalse(result)
    }
}
