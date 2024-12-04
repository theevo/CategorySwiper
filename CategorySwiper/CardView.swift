//
//  CardView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/30/24.
//

import SwiftUI

enum PreviewScreen {
    static let size = UIScreen.main.bounds.size
}

struct CardView: View {
    var transaction: TransactionViewModel
    var size: CGSize = PreviewScreen.size
    
    var width: CGFloat {
        size.width * 0.9
    }
    
    var height: CGFloat {
        size.height * 0.8
    }
    
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
        .frame(width: width, height: height)
    }
}

#Preview {
    CardView(transaction: TransactionViewModel.example)
}
