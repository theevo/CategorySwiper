//
//  NetworkTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 12/6/24.
//

import XCTest
@testable import CategorySwiper

@MainActor
final class NetworkTests: XCTestCase {

    func test_NetworkInterace_with_INVALID_BearerToken_resultsInFailure_HTTPStatusCode_401() async {
        let key = "junktoken"
        
        let session = URLSessionBuilder(bearerToken: key)
        
        let request = LMNetworkInterface.Request.GetTransactions.makeRequest()
        
        let result = await session.execute(request: request)
        
        guard case .failure(let error) = result else {
            XCTFail("We sent the server a junk token and expected a failure. Instead, we got a success?")
            return
        }
        
        guard case .HTTPStatusCode(let response) = error else {
            XCTFail("We sent the server a junk token and expected a 401 status failure. Instead, we got this error: \(error)")
            return
        }
        
        XCTAssertEqual(response.statusCode, 401)
    }
    
    func test_InterfaceManager_getTransactions_resultsInNonEmptyTransactions() async throws {
        let manager = InterfaceManager()
        try await manager.getUnclearedTransactions(withinPrecedingMonths: 12)
        XCTAssertTrue(manager.transactions.notEmpty)
    }
    
    func test_InterfaceManager_updateTransactionStatus_returnsTrueInResponse() async throws {
        let manager = InterfaceManager()
        let response = try await manager.clear(transaction: Transaction.exampleCentralMarket)
        XCTAssertTrue(response)
    }
    
    func test_InterfaceManager_getCategories_returnIsNotEmpty() async throws {
        let manager = InterfaceManager()
        try await manager.getCategories()
        XCTAssertTrue(manager.categories.notEmpty)
        
        let category = manager.categories.first {
            $0.name.contains("1 Off")
        }
        XCTAssertEqual(category?.name, "1 Off")
        
        let category2 = manager.categories.first {
            $0.name.contains("Apple")
        }
        XCTAssertNil(category2)
    }
    
    func test_InterfaceManager_updateTransaction_newCategory_responseIsTrue() async throws {
        let manager = InterfaceManager()
        
        let response = try await manager.updateAndClear(transaction: Transaction.exampleCentralMarket, newCategory: Category.exampleGroceries)
        XCTAssertTrue(response)
    }
    
    func test_NetworkInterface_findOldestUnclearedTransaction_returnsNotNil() async throws {
        let interface = LMNetworkInterface()
        
        let transaction = try await interface.findOldestUnclearedTransaction()
        XCTAssertNotNil(transaction)
    }
}

final class NetworkRequestTests: XCTestCase {
    func test_ClearStatus_containsClearedInBody() throws {
        let transaction = Transaction.exampleDummy
        let request = LMNetworkInterface.Request.ClearStatus(transaction: transaction).makeRequest()
        XCTAssertNotNil(request?.httpBody)
        
        let string = request!.httpBody!.jsonFlatString
        XCTAssertTrue(string.contains("\"cleared"))
        print(string)
    }
    
    func test_UpdateCategoryAndClearStatus_containsCategoryId_andClearedInBody() throws {
        let transaction = Transaction.exampleDummy
        let request = LMNetworkInterface.Request.UpdateCategoryAndClearStatus(transaction: transaction, newCategory: Category.exampleGas).makeRequest()
        XCTAssertNotNil(request?.httpBody)
        
        let string = request!.httpBody!.jsonFlatString
        XCTAssertTrue(string.contains("\"cleared"))
        XCTAssertTrue(string.contains("category_id"))
        print(string)
    }
}
