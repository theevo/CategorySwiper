//
//  LunchMoneyInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

protocol LunchMoneyInterface {
    func clear(transaction: Transaction) async throws -> Bool
    func getCategories() async throws -> CategoryResponseWrapper
    func getTransactions(showUnclearedOnly: Bool, monthsAgo: UInt?) async throws -> TransactionsResponseWrapper
    func updateAndClear(transaction: Transaction, newCategory: Category?) async throws -> Bool
}

protocol LunchMoneyLocalInterface: LunchMoneyInterface {
    func clear(transaction: Transaction) -> Bool
    func getCategories() throws -> CategoryResponseWrapper
    func getTransactions(showUnclearedOnly: Bool, monthsAgo: UInt?) throws -> TransactionsResponseWrapper
    func updateAndClear(transaction: Transaction, newCategory: Category?) -> Bool
}

struct LMLocalInterface: LunchMoneyLocalInterface {
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
    
    func loadTransactions(showUnclearedOnly: Bool = false, limit: Int = .max) throws -> [Transaction] {
        let object = try getTransactions(showUnclearedOnly: showUnclearedOnly)
        return Array(object.transactions.prefix(limit))
    }
    
    func getTransactions(showUnclearedOnly: Bool = false, monthsAgo: UInt? = nil) throws -> TransactionsResponseWrapper {
        let url = Bundle.main.url(forResource: "example-transactions", withExtension: "json")!
        
        do {
            let object = try JSONDecoder().decode(TransactionsResponseWrapper.self, from: try Data(contentsOf: url))
            
            guard showUnclearedOnly else {
                return object
            }
            
            let filteredTransactions = object.transactions.filter { $0.status == .uncleared }
            
            let newObject = TransactionsResponseWrapper(transactions: filteredTransactions)
            
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
    func clear(transaction: Transaction) -> Bool {
        return true
    }
    
    func getCategories() -> CategoryResponseWrapper {
        return CategoryResponseWrapper(categories: [])
    }
    
    func getTransactions(showUnclearedOnly: Bool, monthsAgo: UInt? = nil) -> TransactionsResponseWrapper {
        return TransactionsResponseWrapper(transactions: [])
    }
    
    func updateAndClear(transaction: Transaction, newCategory: Category?) -> Bool {
        return false
    }
}
