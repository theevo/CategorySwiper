//
//  LunchMoneyInterface.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

protocol LunchMoneyInterface {
    func load(showUnclearedOnly: Bool) async throws -> (TopLevelObject, Int)
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool
}

struct LMLocalInterface: LunchMoneyInterface {
    func loadTransactions(showUnclearedOnly: Bool = false, limit: Int = .max) throws -> [Transaction] {
        let (object, _) = try load(showUnclearedOnly: showUnclearedOnly)
        return Array(object.transactions.prefix(limit))
    }
    
    func load(showUnclearedOnly: Bool = false) throws -> (TopLevelObject, Int) {
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

struct LMNetworkInterface: LunchMoneyInterface {
    func load(showUnclearedOnly: Bool = false) async throws -> (TopLevelObject, Int) {
        var object: TopLevelObject = TopLevelObject(transactions: [])
        var statusCode = 0
        
        let interface = URLSessionBuilder()
        
        let filters = showUnclearedOnly ? [URLSessionBuilder.Filter.Uncleared] : []
        
        let result = await interface.getTransactions(filters: filters)
        
        if case .failure(let error) = result {
            throw LoaderError.SessionErrorThrown(error: error)
        }
        
        guard case .success(let response) = result else {
            throw LoaderError.Unknown
        }
        
        // check for status 200
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
        
        do {
            object = try JSONDecoder().decode(TopLevelObject.self, from: response.data)
        } catch (let error) {
            throw LoaderError.JSONFailure(error: error)
        }
        
        return (object, statusCode)
    }
    
    func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool {
        
        let result = await URLSessionBuilder().update(transaction: transaction, newStatus: newStatus)
        
        switch result {
        case .success(let response):
            do {
                let object = try JSONDecoder().decode(UpdateTransactionResponseObject.self, from: response.data)
                return object.updated
            } catch (let error) {
                throw LoaderError.JSONFailure(error: error)
            }
        case .failure(let error):
            throw LoaderError.SessionErrorThrown(error: error)
        }
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
