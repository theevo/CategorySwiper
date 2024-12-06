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
    @Binding var transaction: CardViewModel
    var isTop: Bool = false
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
                Text(transaction.category + "?")
                    .font(.largeTitle)
                Text("\n")
                VStack {
                    Text(transaction.merchant)
                        .font(.title2)
                    Text(transaction.date)
                    Text(transaction.amount, format: .currency(code: transaction.currency))
                }
                .padding()
                .background(HierarchicalShapeStyle.quinary)
            }
        }
        .frame(width: width, height: height)
    }
}

struct CardViewWithExamplePreview: View {
    @State var example: CardViewModel = CardViewModel.example
    
    var body: some View {
        CardView(transaction: $example)
    }
}

#Preview {
    CardViewWithExamplePreview()
}
