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
    @Binding var card: CardViewModel
    var isTop: Bool = false
    var isSecond: Bool = false
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
                Text(card.category + "?")
                    .font(.largeTitle)
                Text("\n")
                VStack {
                    Text(card.merchant)
                        .font(.title2)
                    Text(card.date)
                    Text(card.amount, format: .currency(code: card.currency))
                }
                .padding()
                .background(HierarchicalShapeStyle.quinary)
            }
        }
        .frame(width: width, height: height)
    }
    
    private func getShadowColor() -> Color {
        if isSecond { return Color.secondary }
        
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
    @State var example: CardViewModel
    var isTop: Bool = true
    var dragOffset: CGSize = .zero
    
    var body: some View {
        CardView(card: $example, isTop: isTop, dragOffset: dragOffset)
    }
}

#Preview("Default") {
    CardViewWithExamplePreview(example: CardViewModel.example)
}

#Preview("Swipe Left") {
    CardViewWithExamplePreview(
        example: CardViewModel.example,
        dragOffset: CGSize(width: -10, height: 0)
    )
}

#Preview("Swipe Right") {
    CardViewWithExamplePreview(
        example: CardViewModel.example,
        dragOffset: CGSize(width: 10, height: 0)
    )
}

#Preview("Uncategorized") {
    CardViewWithExamplePreview(
        example: CardViewModel(transaction: Transaction.exampleUncategorized)
    )
}
