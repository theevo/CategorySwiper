//
//  LunchMoneyInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

protocol LunchMoneyInterface {
    var bearerToken: String { get }
    func clear(transaction: Transaction) async throws -> Bool
    func getCategories() async throws -> CategoryResponseWrapper
    func getUnclearedTransactions(withinPrecedingMonths: UInt?) async throws -> TransactionsResponseWrapper
    func isBearerTokenValid() async -> Bool
    func removeBearerToken()
    func saveBearerToken(_ token: String)
    func updateAndClear(transaction: Transaction, newCategory: Category?) async throws -> Bool
}

protocol LunchMoneyLocalInterface: LunchMoneyInterface {
    var bearerToken: String { get }
    func clear(transaction: Transaction) -> Bool
    func getCategories() throws -> CategoryResponseWrapper
    func getUnclearedTransactions(withinPrecedingMonths: UInt?) throws -> TransactionsResponseWrapper
    func isBearerTokenValid() -> Bool
    func removeBearerToken()
    func saveBearerToken(_ token: String)
    func updateAndClear(transaction: Transaction, newCategory: Category?) -> Bool
}

extension LunchMoneyLocalInterface {
    func removeBearerToken() {
        print("\(#function) called for a Local Interface.")
    }
    
    func saveBearerToken(_ token: String) {
        print("\(#function) called for a Local Interface.")
    }
}

struct LMLocalInterface: LunchMoneyLocalInterface {
    var bearerToken: String {
        return "Bearer_Token-for*Local^Interface"
    }
    
    func clear(transaction: Transaction) -> Bool {
        return true
    }
    
    func getCategories() throws -> CategoryResponseWrapper {
        let url = Bundle.main.url(forResource: "example-categories", withExtension: "json")!
        
        do {
            let object = try JSONDecoder().decode(CategoryResponseWrapper.self, from: try Data(contentsOf: url))
            return object
        } catch {
            throw LoaderError.JSONFailure(error: error)
        }
    }
    
    func isBearerTokenValid() -> Bool {
        return true
    }
    
    func loadTransactions(showUnclearedOnly: Bool = false, limit: Int = .max) throws -> [Transaction] {
        let object = try getTransactions(showUnclearedOnly: showUnclearedOnly)
        return Array(object.transactions.prefix(limit))
    }
    
    func getUnclearedTransactions(withinPrecedingMonths: UInt?) throws -> TransactionsResponseWrapper {
        return try getTransactions(showUnclearedOnly: true, withinPrecedingMonths: withinPrecedingMonths)
    }
    
    func getTransactions(showUnclearedOnly: Bool = false, monthsAgo: UInt? = nil, withinPrecedingMonths: UInt? = nil) throws -> TransactionsResponseWrapper {
        let url = Bundle.main.url(forResource: "example-transactions", withExtension: "json")!
        
        do {
            let object = try JSONDecoder().decode(TransactionsResponseWrapper.self, from: try Data(contentsOf: url))
            
            guard showUnclearedOnly else {
                return object
            }
            
            let filteredTransactions = object.transactions.filter { $0.status == .uncleared }
            
            let newObject = TransactionsResponseWrapper(transactions: filteredTransactions, has_more: false)
            
            return newObject
        } catch {
            throw LoaderError.JSONFailure(error: error)
        }
    }
    
    func updateAndClear(transaction: Transaction, newCategory: Category?) -> Bool {
        guard let newCategory = newCategory,
              transaction.category_id != newCategory.id else { return false }
        
        return true
    }
}

enum LoaderError: LocalizedError {
    case SessionErrorThrown(error: URLSessionBuilder.SessionError)
    case Unknown
    case JSONFailure(error: Error)
    case StatusCode(Int)
    
    var errorDescription: String? {
        switch self {
        case .SessionErrorThrown(error: let error):
            error.errorDescription
        case .Unknown:
            "URLSessionBuilder returned a success, but it could not unpack the response."
        case .JSONFailure(error: let error):
            "\(#file) \(#function) line \(#line): JSONDecoder failed. Error detail: \(error.localizedDescription)"
        case .StatusCode(let statusCode):
            "\(#file) \(#function) line \(#line): URLSession returned status code \(statusCode)"
        }
    }
}

struct LMEmptyInterface: LunchMoneyLocalInterface {
    var bearerToken: String {
        ""
    }
    
    func clear(transaction: Transaction) -> Bool {
        return true
    }
    
    func getCategories() -> CategoryResponseWrapper {
        return CategoryResponseWrapper(categories: [])
    }
    
    func getUnclearedTransactions(withinPrecedingMonths: UInt?) throws -> TransactionsResponseWrapper {
        return TransactionsResponseWrapper(transactions: [], has_more: false)
    }
    
    func isBearerTokenValid() -> Bool {
        print("empty interface will return false")
        return false
    }
    
    func updateAndClear(transaction: Transaction, newCategory: Category?) -> Bool {
        return false
    }
}
