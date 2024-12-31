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
    
    init(dataSource: DataSource = .Production) {
        switch dataSource {
        case .Production:
            self.interface = LMNetworkInterface()
        case .Local:
            self.interface = LMLocalInterface()
        case .Empty:
            self.interface = LMEmptyInterface()
        }
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

extension InterfaceManager {
    /// __Production__: Internet API call to LunchMoney API
    /// __Local__: JSON file in the Bundle with several transactions and categories copied from live data. Great for Tests and Previews
    /// __Empty__: Zero transactions, Zero categories. Great for Tests and Previews.
    enum DataSource {
        case Production, Local, Empty
    }
}
