//
//  CardView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import SwiftUI

struct TransactionViewModel {
    var merchant: String
    var date: String
    var amount: Float
    var rawCurrency: String
    var category_name: String?
    
    var currency: String {
        rawCurrency.uppercased()
    }
    
    var category: String {
        category_name ?? "No Category Assigned"
    }
}

extension TransactionViewModel {
    static let example = TransactionViewModel(transaction: Transaction.example)
    
    init(transaction: Transaction) {
        self.merchant = transaction.payee
        self.date = transaction.date
        self.amount = transaction.to_base
        self.rawCurrency = transaction.currency
        self.category_name = transaction.category_name
    }
}


struct CardView: View {
    var viewModel: TransactionViewModel
    
    var body: some View {
        Text(viewModel.merchant)
            .font(.title)
        Text(viewModel.amount, format: .currency(code: viewModel.currency))
            .font(.largeTitle)
        Text(viewModel.date)
        Text(viewModel.category)
    }
}

#Preview {
    CardView(viewModel: TransactionViewModel.example)
}
