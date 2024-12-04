//
//  CardView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import SwiftUI

struct CardView: View {
    var transaction: TransactionViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: 45,
                style: .continuous
            )
                .fill(.background)
                .shadow(color: .secondary, radius: 10)
            VStack {
                Text(transaction.merchant)
                    .font(.title)
                Text(transaction.amount, format: .currency(code: transaction.currency))
                    .font(.largeTitle)
                Text(transaction.date)
                Text(transaction.category)
            }
        }
    }
}

#Preview {
    CardView(transaction: TransactionViewModel.example)
}
