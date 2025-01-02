//
//  LunchMoneyInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

protocol LunchMoneyInterface {
    func getCategories() async throws -> CategoryResponseWrapper
    func getTransactions(showUnclearedOnly: Bool, monthsAgo: UInt?) async throws -> TransactionsResponseWrapper
    func update(transaction: Transaction, newCategory: Category) async throws -> Bool
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool
}

struct LMLocalInterface: LunchMoneyInterface {
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
    
    func update(transaction: Transaction, newCategory: Category) -> Bool {
        guard transaction.category_id != newCategory.id else { return false }
        
        return true
    }
    
    func update(transaction: Transaction, newStatus: Transaction.Status) -> Bool {
        guard transaction.status != newStatus else { return false }
        
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

struct LMEmptyInterface: LunchMoneyInterface {
    func getCategories() async throws -> CategoryResponseWrapper {
        return CategoryResponseWrapper(categories: [])
    }
    
    func getTransactions(showUnclearedOnly: Bool, monthsAgo: UInt? = nil) async throws -> TransactionsResponseWrapper {
        return TransactionsResponseWrapper(transactions: [])
    }
    
    func update(transaction: Transaction, newCategory: Category) async throws -> Bool {
        return false
    }
    
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool {
        return false
    }
}
