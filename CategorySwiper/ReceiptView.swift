//
//  ReceiptView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import SwiftUI

struct ReceiptView: View {
    var transaction: CardViewModel
    let reduction: CGFloat = 0.6
    
    var width: CGFloat {
        PreviewScreen.size.width * reduction
    }
    
    var height: CGFloat {
        PreviewScreen.size.height * reduction
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
                .shadow(color: .secondary, radius: 10)
            VStack {
                VStack(alignment: .leading) {
                    Text(transaction.merchant)
                    Text(transaction.date)
                }
                .frame(width: width, alignment: .leading)
                VStack(alignment: .trailing) {
                    Text(transaction.amount, format: .currency(code: transaction.currency))
                }
                .frame(width: width, alignment: .trailing)
            }
            .frame(width: width, height: height)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    ReceiptView(transaction: CardViewModel.example)
}
