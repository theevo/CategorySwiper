//
//  TransactionViewModel.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import Foundation

struct TransactionViewModel: Identifiable {
    var id: Int
    var merchant: String
    var date: String
    var amount: Float
    var rawCurrency: String
    var category_name: String?
    var swipeDirection: SwipeDirection = .none
    
    var currency: String {
        rawCurrency.uppercased()
    }
    
    var category: String {
        category_name ?? "No Category Assigned"
    }
    
    enum SwipeDirection {
        case left, right, none
    }
}

extension TransactionViewModel {
    static let example = TransactionViewModel(transaction: Transaction.example)
    
    init(transaction: Transaction) {
        self.id = transaction.id
        self.merchant = transaction.payee
        self.date = transaction.date
        self.amount = transaction.to_base
        self.rawCurrency = transaction.currency
        self.category_name = transaction.category_name
    }
    
    static func getExamples(showUnclearedOnly: Bool = true, limit: Int = 5) -> [TransactionViewModel] {
        let transactions = try! LocalTransactionsLoader().loadTransactions(showUnclearedOnly: showUnclearedOnly, limit: limit)
        return transactions.map(TransactionViewModel.init)
    }
}
