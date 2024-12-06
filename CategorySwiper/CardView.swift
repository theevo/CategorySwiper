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
    var dragOffset: CGSize = .zero
    
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
                .shadow(color: getShadowColor(), radius: 10)
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
    
    private func getShadowColor() -> Color {
        guard isTop else { return Color.clear }
        
        if dragOffset.width > 0 {
            return Color.green.opacity(0.5)
        } else if dragOffset.width < 0 {
            return Color.red.opacity(0.5)
        } else {
            return Color.secondary
        }
    }
}

struct CardViewWithExamplePreview: View {
    @State var example: CardViewModel = CardViewModel.example
    var isTop: Bool = true
    var dragOffset: CGSize = .zero
    
    var body: some View {
        CardView(transaction: $example, isTop: isTop, dragOffset: dragOffset)
    }
}

#Preview("Default") {
    CardViewWithExamplePreview()
}

#Preview("Swipe Left") {
    CardViewWithExamplePreview(dragOffset: CGSize(width: -10, height: 0))
}

#Preview("Swipe Right") {
    CardViewWithExamplePreview(dragOffset: CGSize(width: 10, height: 0))
}
