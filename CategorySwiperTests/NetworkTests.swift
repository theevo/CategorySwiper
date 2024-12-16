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
        
        let interface = NetworkInterface(bearerToken: key)
        
        let result = await interface.getTransactions()
        
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
        let loader = LunchMoneyTransactionsLoader()
        
        do {
            let result = try await loader.load()
            let responseCode = result.1
            XCTAssertEqual(responseCode, 200)
            let object = result.0
            XCTAssertTrue(object.transactions.notEmpty)
        } catch {
            XCTFail("Error: LunchMoneyTransactionsLoader returned this error: \(error)")
        }
    }
    
    func test_LunchMoneyTransactionLoader_updateTransactionStatus_returnsTrueInResponse() async {
        
        let loader = LunchMoneyTransactionsLoader()
        
        do {
            let result = try await loader.update(transaction: Transaction.example, newStatus: .cleared)
            XCTAssertTrue(result)
        } catch {
            XCTFail("Error: LunchMoneyTransactionsLoader returned this error: \(error)")
        }
        
    }
        
}
