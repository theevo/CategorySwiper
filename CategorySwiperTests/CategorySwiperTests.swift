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
        
        let result = await interface.getTransactions()
        
        guard case .success(let response) = result else {
            XCTFail("URLSession failed")
            return
        }
        
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 401)
        }
    }
    
    func test_apiCall_responseData_decodesSuccessfully() async {
        let interface = NetworkInterface()
        
        let result = await interface.getTransactions()
        
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
        
        do {
            let object = try JSONDecoder().decode(TopLevelObject.self, from: data)
            XCTAssertFalse(object.transactions.isEmpty)
            
            print("Transactions #:", object.transactions.count)
            
            let cleared = object.transactions.filter({ $0.status == .cleared })
            print(" Cleared #:", cleared.count)
            
            let uncleared = object.transactions.filter({ $0.status == .uncleared })
            print(" Uncleared #:", uncleared.count)
            
            let pending = object.transactions.filter({ $0.status == .pending })
            print(" Pending #:", pending.count)
            
        } catch {
            print("\(#file) \(#function) line \(#line): JSONDecoder failed")
            print("error: \(error)")
        }
    }
    
    func test_apiCall_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async {
        let interface = NetworkInterface()
        
        let filters = [NetworkInterface.Filter.Uncleared]
        
        let result = await interface.getTransactions(filters: filters)
        
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
        
        do {
            let object = try JSONDecoder().decode(TopLevelObject.self, from: data)
            let totalCount = object.transactions.count
            print("Transactions #:", totalCount)
            
            let uncleared = object.transactions.filter({ $0.status == .uncleared })
            print(" Uncleared #:", uncleared.count)
            XCTAssertEqual(totalCount, uncleared.count)
        } catch {
            print("\(#file) \(#function) line \(#line): JSONDecoder failed")
            print("error: \(error)")
        }
    }
}
