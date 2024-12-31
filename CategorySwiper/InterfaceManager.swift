//
//  InterfaceManager.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/26/24.
//

import Foundation

@MainActor class InterfaceManager: ObservableObject {
    private let interface: LunchMoneyInterface
    @Published var categories: [Category] = []
    @Published var transactions: [Transaction] = []
    
    var uncleared: [Transaction] {
        transactions.filter({ $0.status == .uncleared })
    }
    
    init(localMode: Bool = false) {
        self.interface = localMode ? LMLocalInterface() : LMNetworkInterface()
    }
    
    func loadData() async throws {
        async let getTheCategories: () = getCategories()
        async let getTheTransactions: () = getTransactions(showUnclearedOnly: true)
        let _ = try await (getTheCategories, getTheTransactions)
    }
    
    public func getCategories() async throws {
        let response = try await interface.getCategories()
        self.categories = response.categories
        print("☑️ finished loading \(self.categories.count) categories")
    }
    
    public func getTransactions(showUnclearedOnly: Bool = false) async throws {
        let response = try await interface.getTransactions(showUnclearedOnly: showUnclearedOnly)
        self.transactions = response.transactions
        print("☑️ finished loading \(self.transactions.count) transactions")
    }
    
    public func update(transaction: Transaction, newCategory: Category) async throws -> Bool {
        return try await interface.update(transaction: transaction, newCategory: newCategory)
    }
    
    public func update(transaction: Transaction, newStatus: Transaction.Status) async throws -> Bool {
        return try await interface.update(transaction: transaction, newStatus: newStatus)
    }
}
