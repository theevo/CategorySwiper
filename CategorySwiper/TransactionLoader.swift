//
//  TransactionLoader.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

protocol TransactionsLoader {
    func load(showUnclearedOnly: Bool) async throws -> (TopLevelObject, Int)
}

struct LocalTransactionsLoader: TransactionsLoader {
    func loadTransactions(showUnclearedOnly: Bool = false, limit: Int) async throws -> [Transaction] {
        let (object, _) = try await load(showUnclearedOnly: showUnclearedOnly)
        return Array(object.transactions.prefix(limit))
    }
    
    func load(showUnclearedOnly: Bool = false) async throws -> (TopLevelObject, Int) {
        let url = Bundle.main.url(forResource: "example-transactions", withExtension: "json")!
        
        do {
            let object = try JSONDecoder().decode(TopLevelObject.self, from: try Data(contentsOf: url))
            
            guard showUnclearedOnly else {
                return (object, 200)
            }
            
            var filteredTransactions: [Transaction] = []
            
            object.transactions.forEach { transaction in
                if transaction.status == .uncleared {
                    filteredTransactions.append(transaction)
                }
            }
            
            let newObject = TopLevelObject(transactions: filteredTransactions)
            
            return (newObject, 200)
        } catch {
            throw LoaderError.JSONFailure(error: error)
        }
    }
}

struct LunchMoneyTransactionsLoader: TransactionsLoader {
    func load(showUnclearedOnly: Bool = false) async throws -> (TopLevelObject, Int) {
        var object: TopLevelObject = TopLevelObject(transactions: [])
        var statusCode = 0
        
        let interface = NetworkInterface()
        
        let filters = showUnclearedOnly ? [NetworkInterface.Filter.Uncleared] : []
        
        let result = await interface.getTransactions(filters: filters)
        
        if case .failure(let error) = result {
            throw LoaderError.NetworkInterfaceError(error: error)
        }
        
        guard case .success(let response) = result else {
            throw LoaderError.Unknown
        }
        
        // check for status 200
        if let httpResponse = response.urlResponse as? HTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
        
        // check data for Error
        guard let data = response.data else {
            throw LoaderError.DataFailure
        }
        
        do {
            object = try JSONDecoder().decode(TopLevelObject.self, from: data)
        } catch (let error) {
            throw LoaderError.JSONFailure(error: error)
        }
        
        return (object, statusCode)
    }
}

enum LoaderError: LocalizedError {
    case NetworkInterfaceError(error: NetworkInterface.SessionError)
    case Unknown
    case DataFailure
    case JSONFailure(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .NetworkInterfaceError(error: let error):
            error.errorDescription
        case .Unknown:
            "NetworkInterface returned a success, but it could not unpack the response."
        case .DataFailure:
            "Failed to unwrap the data"
        case .JSONFailure(error: let error):
            "\(#file) \(#function) line \(#line): JSONDecoder failed. Error detail: \(error.localizedDescription)"
        }
    }
}
