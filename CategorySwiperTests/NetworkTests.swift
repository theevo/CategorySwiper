//
//  NetworkTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 12/6/24.
//

import XCTest
@testable import CategorySwiper

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
    
    func test_LunchMoneyTransactionLoader_with_VALID_BearerToken_resultsIn_200statusCode() async {
        let interface = LMNetworkInterface()
        
        do {
            let response = try await interface.getTransactions()
            XCTAssertTrue(response.transactions.notEmpty)
        } catch {
            XCTFail("Error: LMNetworkInterface returned this error: \(error)")
        }
    }
    
    func test_LunchMoneyTransactionLoader_updateTransactionStatus_returnsTrueInResponse() async {
        let interface = LMNetworkInterface()
        
        do {
            let response = try await interface.update(transaction: Transaction.example, newStatus: .cleared)
            XCTAssertTrue(response)
        } catch {
            XCTFail("Error: LMNetworkInterface returned this error: \(error)")
        }
    }
    
    func test_LMNetworkInterface_getCategories_returnIsNotEmpty() async {
        let interface = LMNetworkInterface()
        
        do {
            let response = try await interface.getCategories()
            XCTAssertTrue(response.categories.notEmpty)
        } catch {
            XCTFail("Error: LMNetworkInterface returned this error: \(error)")
        }
    }
    
    func test_LMNetworkInterface_updateTransaction_newCategory_responseIsTrue() async {
        let interface = LMNetworkInterface()
        
        do {
            let response = try await interface.update(transaction: Transaction.example, newCategory: Category.exampleGroceries)
            XCTAssertTrue(response)
        } catch {
            XCTFail("Error: LMNetworkInterface returned this error: \(error)")
        }
    }
}
