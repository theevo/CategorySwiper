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
    
    func test_NetworkInterface_updateStatus_resultsIn_200statusCode() async throws {
        let interface = NetworkInterface()
        
        let result = try await interface.update(transaction: Transaction.example, status: .cleared)
        
        if case .failure(let error) = result {
            XCTFail("Error: NetworkInterface returned this error: \(error)")
        }
        
        guard case .success(let response) = result else {
            XCTFail("URLSession failed")
            return
        }
        
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            print(response)
            XCTAssertEqual(httpResponse.statusCode, 200)
        }
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
}
