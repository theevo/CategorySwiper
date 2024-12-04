//
//  SwipeableCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/4/24.
//

import SwiftUI

struct SwipeableCardsView: View {
    var transactions: [TransactionViewModel]
    
    var body: some View {
        ForEach(transactions) { transaction in
            CardView(viewModel: transaction)
        }
    }
}

#Preview {
    SwipeableCardsView(transactions: [TransactionViewModel.example])
}
