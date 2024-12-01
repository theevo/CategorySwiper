//
//  CardView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import SwiftUI

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
