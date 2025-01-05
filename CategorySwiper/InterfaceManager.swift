//
//  InterfaceManager.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/26/24.
//

import Foundation

@MainActor class InterfaceManager: ObservableObject {
    private let dataSource: DataSource
    private let interface: LunchMoneyInterface
    var categories: [Category] = []
    var transactions: [Transaction] = []
    @Published var appState: AppState = .Fetching
    @Published var cardsModel: SwipeableCardsModel = SwipeableCardsModel.empty
    
    var uncleared: [Transaction] {
        transactions.filter({ $0.status == .uncleared })
    }
    
    init(dataSource: DataSource = .Production) {
        print("💿 running in \(dataSource)")
        self.dataSource = dataSource
        switch dataSource {
        case .Production:
            self.interface = LMNetworkInterface()
        case .Local:
            self.interface = LMLocalInterface()
        case .Empty:
            self.interface = LMEmptyInterface()
        }
        runTaskAndAdvanceState()
    }
    
    public func runTaskAndAdvanceState() {
        switch appState {
        case .Fetching:
            if dataSource == .Production {
                Task {
                    print("calling loadData")
                    try await loadData()
                    if transactions.isEmpty {
                        appState = .FetchEmpty
                    } else {
                        appState = .Swiping
                        cardsModel = SwipeableCardsModel(transactions: transactions)
                    }
                }
            } else {
                loadDataFromLocal()
                if transactions.isEmpty {
                    appState = .FetchEmpty
                } else {
                    appState = .Swiping
                    cardsModel = SwipeableCardsModel(transactions: transactions)
                }
            }
        case .FetchEmpty:
            print("no transactions")
        case .Swiping:
            processSwipes()
            appState = .Done
        case .Done:
            print("done swiping")
        }
    }
    
    private func loadDataFromLocal() {
        var localInterface: any LunchMoneyLocalInterface
        
        if dataSource == .Local {
            localInterface = interface as! LMLocalInterface
        } else if dataSource == .Empty {
            localInterface = interface as! LMEmptyInterface
        } else {
            return
        }
        
        if let response = try? localInterface.getTransactions(showUnclearedOnly: true, monthsAgo: nil) {
            self.transactions = response.transactions
        }
        
        if let wrapper = try? localInterface.getCategories() {
            self.categories = wrapper.categories
        }
    }
    
    fileprivate func processSwipes() {
        // batch process swipedCards
        for card in cardsModel.swipedCards {
            Task {
                let transaction = card.transaction
                
                if card.swipeDirection == .right {
                    let result = try await clear(transaction: transaction)
                    print("\(card.merchant) status update result: \(result ? "✅" : "❌")")
                } else if card.swipeDirection == .left {
//                    let result = try await update(transaction: transaction, newCategory: <#T##Category#>)
                    print("\(card.merchant) - \(card.category)")
                }
            }
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
        print("☑️ finished loading \(self.categories.count) categories at \(Date().formatted())")
    }
    
    public func getTransactions(showUnclearedOnly: Bool = false, monthsAgo: UInt? = nil) async throws {
        let response = try await interface.getTransactions(showUnclearedOnly: showUnclearedOnly, monthsAgo: monthsAgo)
        self.transactions = response.transactions
        print("☑️ finished loading \(self.transactions.count) transactions at \(Date().formatted())")
    }
    
    public func update(transaction: Transaction, newCategory: Category) async throws -> Bool {
        return try await interface.update(transaction: transaction, newCategory: newCategory)
    }
    
    public func clear(transaction: Transaction) async throws -> Bool {
        return try await interface.clear(transaction: transaction)
    }
}

extension InterfaceManager {
    /// __Production__: Internet API call to LunchMoney API
    /// __Local__: JSON file in the Bundle with several transactions and categories copied from live data. Great for Tests and Previews
    /// __Empty__: Zero transactions, Zero categories. Great for Tests and Previews.
    enum DataSource {
        case Production, Local, Empty
    }
    
    enum AppState: String {
        case Fetching
        case FetchEmpty
        case Swiping
        case Done
    }
}
