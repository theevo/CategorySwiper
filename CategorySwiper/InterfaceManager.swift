//
//  InterfaceManager.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/26/24.
//

import Foundation

class InterfaceManager: ObservableObject {
    private let interface: LunchMoneyInterface
    var categories: [Category] = []
    var transactions: [Transaction] = []
    
    var uncleared: [Transaction] {
        transactions.filter({ $0.status == .uncleared })
    }
    
    init(localMode: Bool = false) {
        self.interface = localMode ? LMLocalInterface() : LMNetworkInterface()
    }
    
    public func getCategories() async throws {
        let response = try await interface.getCategories()
        self.categories = response.categories
    }
    
    public func getTransactions(showUnclearedOnly: Bool = false) async throws {
        let response = try await interface.getTransactions(showUnclearedOnly: showUnclearedOnly)
        self.transactions = response.transactions
    }
    
    public func update(transaction: Transaction, newCategory: Category) async throws -> Bool {
        return try await interface.update(transaction: transaction, newCategory: newCategory)
    }
}
