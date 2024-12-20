//
//  LunchMoneyInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

protocol LunchMoneyInterface {
    func getTransactions(showUnclearedOnly: Bool) async throws -> (TopLevelObject, Int)
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool
}

struct LMLocalInterface: LunchMoneyInterface {
    func loadTransactions(showUnclearedOnly: Bool = false, limit: Int = .max) throws -> [Transaction] {
        let (object, _) = try getTransactions(showUnclearedOnly: showUnclearedOnly)
        return Array(object.transactions.prefix(limit))
    }
    
    func getTransactions(showUnclearedOnly: Bool = false) throws -> (TopLevelObject, Int) {
        let url = Bundle.main.url(forResource: "example-transactions", withExtension: "json")!
        
        do {
            let object = try JSONDecoder().decode(TopLevelObject.self, from: try Data(contentsOf: url))
            
            guard showUnclearedOnly else {
                return (object, 200)
            }
            
            let filteredTransactions = object.transactions.filter { $0.status == .uncleared }
            
            let newObject = TopLevelObject(transactions: filteredTransactions)
            
            return (newObject, 200)
        } catch {
            throw LoaderError.JSONFailure(error: error)
        }
    }
    
    func update(transaction: Transaction, newStatus: Transaction.Status) throws -> Bool {
        return true
    }
}

enum LoaderError: LocalizedError {
    case SessionErrorThrown(error: URLSessionBuilder.SessionError)
    case Unknown
    case JSONFailure(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .SessionErrorThrown(error: let error):
            error.errorDescription
        case .Unknown:
            "URLSessionBuilder returned a success, but it could not unpack the response."
        case .JSONFailure(error: let error):
            "\(#file) \(#function) line \(#line): JSONDecoder failed. Error detail: \(error.localizedDescription)"
        }
    }
}
