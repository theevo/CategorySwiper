//
//  InterfaceManager.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/26/24.
//

import Foundation

@MainActor class InterfaceManager: ObservableObject {
    var swipeLimit: Int = 5
    private let dataSource: DataSource
    private var interface: LunchMoneyInterface
    var categories: [Category] = []
    var transactions: [Transaction] = []
    var items: [ProgressItem] = []
    @Published var appState: AppState = .Fetching
    @Published var cardsModel: SwipeableCardsModel = SwipeableCardsModel.empty
    @Published var didFindMoreTransactions = false
    @Published var isTokenWorking = false
    
    var uncleared: [Transaction] {
        transactions.filter({ $0.status == .uncleared })
    }
    
    var progressModel: UpdateProgressViewModel {
        UpdateProgressViewModel(items: items)
    }
    
    init(dataSource: DataSource = .Production) {
        LogThisAs.state("💿 running in \(dataSource)")
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
    
    init(dataSource: DataSource, limit: Int) {
        self.swipeLimit = limit
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
                    do {
                        LogThisAs.state("💭 calling loadData")
                        try await loadData()
                        LogThisAs.state("💭 done calling loadData")
                        if transactions.isEmpty {
                            appState = .FetchEmpty
                        } else {
                            appState = .Swiping
                            transactions = Array(transactions.prefix(swipeLimit))
                            cardsModel = SwipeableCardsModel(transactions: transactions)
                        }
                    } catch {
                        LogThisAs.state("FETCHING got error: \(error)")
                        appState = .Debug(message: error.localizedDescription)
                    }
                }
            } else {
                loadDataFromLocal()
                if transactions.isEmpty {
                    appState = .FetchEmpty
                } else {
                    appState = .Swiping
                    transactions = Array(transactions.prefix(swipeLimit))
                    cardsModel = SwipeableCardsModel(transactions: transactions)
                }
            }
        case .FetchEmpty:
            print("0️⃣ no transactions in current month")
            Task {
                print("🔎 searching previous months...")
                try await loadData(willSearchPrecedingMonths: true)
                if transactions.notEmpty {
                    didFindMoreTransactions = true
                } else {
                    print(" no transactions in previous months.")
                }
            }
        case .Swiping:
            Task {
                await processSwipes()
                LogThisAs.state("🤡 processSwipes done")
                appState = .Done
            }
        case .Done:
            print("done swiping")
            var willSearchPrecedingMonths: Bool = false
            
            Task {
                print("🔎 searching CURRENT month...")
                try await loadData()
                if transactions.notEmpty {
                    didFindMoreTransactions = true
                } else {
                    print(" no transactions in current month.")
                    willSearchPrecedingMonths = true
                }
                
                guard willSearchPrecedingMonths else { return }
                
                print("🔎 searching PREVIOUS months...")
                try await loadData(willSearchPrecedingMonths: true)
                if transactions.notEmpty {
                    didFindMoreTransactions = true
                } else {
                    print(" no transactions in previous months.")
                }
            }
        case .Debug(_):
            appState = .Fetching
            runTaskAndAdvanceState()
        }
    }
    
    public func getBearerToken() -> String {
        return interface.bearerToken
    }
    
    public func saveBearerToken(_ token: String) {
        interface.saveBearerToken(token)
        Task { await validateToken() }
    }
    
    public func removeToken() {
        interface.removeBearerToken()
        isTokenWorking = false
    }
    
    public func validateToken() async {
        if dataSource == .Production {
            // refresh the NetworkInterface
            self.interface = LMNetworkInterface()
        }
        
        self.isTokenWorking = await interface.isBearerTokenValid()
    }
    
    public func swipeOnOldTransactions() {
        appState = .Swiping
        transactions = Array(transactions.prefix(swipeLimit))
        cardsModel = SwipeableCardsModel(transactions: transactions)
        didFindMoreTransactions = false
        items = []
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
        
        if let response = try? localInterface.getUnclearedTransactions(withinPrecedingMonths: nil) {
            self.transactions = response.transactions
        }
        
        if let wrapper = try? localInterface.getCategories() {
            self.categories = wrapper.categories
        }
    }
    
    fileprivate func processSwipes() async {
        // batch process swipedCards
        for card in cardsModel.swipedCards {
            let transaction = card.transaction
            
            if card.swipeDirection == .right {
                let item: ProgressItem = ProgressItem(name: "Clear \(card.merchant)") {
                    return try await self.clear(transaction: transaction)
                }
                items.append(item)
            } else if card.swipeDirection == .left {
                let item: ProgressItem = ProgressItem(name: "Clear \(card.merchant) -> \(card.newCategory?.name ?? "<no category>")") {
                    return try await self.updateAndClear(transaction: transaction, newCategory: card.newCategory)
                }
                items.append(item)
            }
        }
    }
    
    func loadData(willSearchPrecedingMonths: Bool = false) async throws {
        let withinPrecedingMonths: UInt? = willSearchPrecedingMonths ? 12 : nil
        async let getTheCategories: () = getCategories()
        async let getTheTransactions: () = getUnclearedTransactions(withinPrecedingMonths: withinPrecedingMonths)
        let _ = try await (getTheCategories, getTheTransactions)
    }
    
    public func getCategories() async throws {
        let response = try await interface.getCategories()
        self.categories = response.categories
        print("☑️ finished loading \(self.categories.count) categories at \(Date().formatted())")
    }
    
    public func getUnclearedTransactions(withinPrecedingMonths: UInt? = nil) async throws {
        let response = try await interface.getUnclearedTransactions(withinPrecedingMonths: withinPrecedingMonths)
        self.transactions = response.transactions
        print("☑️ finished loading \(self.transactions.count) transactions at \(Date().formatted())")
    }
    
    public func updateAndClear(transaction: Transaction, newCategory: Category?) async throws -> Bool {
        return try await interface.updateAndClear(transaction: transaction, newCategory: newCategory)
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
    
    enum AppState: Equatable {
        case Fetching
        case FetchEmpty
        case Swiping
        case Done
        case Debug(message: String)
    }
}

extension InterfaceManager {
    static let previewOldTransactionFound: InterfaceManager = {
        let manager = InterfaceManager(dataSource: .Local)
        manager.didFindMoreTransactions = true
        return manager
    }()
    
    var oldestTransactionDate: String? {
        transactions.first?.date
    }
}
