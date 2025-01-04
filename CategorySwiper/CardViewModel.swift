//
//  CardViewModel.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

struct CardViewModel: Identifiable {
    var id: Int
    var merchant: String
    var date: String
    var amount: Float
    var rawCurrency: String
    var category_id: Int?
    var category_name: String?
    var newCategory: Category?
    var transaction: Transaction
    
    var swipeDirection: SwipeDirection = .none
    
    var currency: String {
        rawCurrency.uppercased()
    }
    
    var category: String {
        category_name ?? "Uncategorized"
    }
    
    init(transaction: Transaction) {
        self.id = transaction.id
        self.merchant = transaction.payee
        self.date = transaction.date
        self.amount = transaction.to_base
        self.rawCurrency = transaction.currency
        self.category_id = transaction.category_id
        self.category_name = transaction.category_name
        self.transaction = transaction
    }
    
    mutating func changeCategoryTo(category: Category?) {
        self.newCategory = category
    }
}

extension CardViewModel {
    static let dummy = CardViewModel(transaction: Transaction.exampleDummy)
    static let example = CardViewModel(transaction: Transaction.exampleCentralMarket)
    
    static func getExamples(showUnclearedOnly: Bool = true, limit: Int = 5, shuffled: Bool = false) -> [CardViewModel] {
        let transactions = try! LMLocalInterface().loadTransactions(showUnclearedOnly: showUnclearedOnly)
        let cards = shuffled ? transactions.map(CardViewModel.init).shuffled() : transactions.map(CardViewModel.init)
        return Array(cards.prefix(limit))
    }
}

extension CardViewModel {
    enum SwipeDirection {
        case left, right, none
    }
}

extension CardViewModel: Equatable {
    
}
