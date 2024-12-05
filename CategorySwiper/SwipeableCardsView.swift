//
//  SwipeableCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/4/24.
//

import SwiftUI

class SwipeableCardsModel: ObservableObject {
    private var originalCards: [CardViewModel]
    @Published var unswipedCards: [CardViewModel]
    @Published var swipedCards: [CardViewModel]
    
    init(transactions: [CardViewModel]) {
        self.originalCards = transactions
        self.unswipedCards = transactions
        self.swipedCards = []
    }
    
    func removeTopCard() {
        if !unswipedCards.isEmpty {
            guard let card = unswipedCards.first else { return }
            unswipedCards.removeFirst()
            swipedCards.append(card)
        }
    }
    
    func updateTopCardSwipeDirection(_ direction: CardViewModel.SwipeDirection) {
        if !unswipedCards.isEmpty {
            unswipedCards[0].swipeDirection = direction
        }
    }
    
    func reset() {
        unswipedCards = originalCards
        swipedCards = []
    }
}

struct SwipeableCardsView: View {
    @ObservedObject var model: SwipeableCardsModel
    
    var body: some View {
        ZStack {
            ForEach($model.unswipedCards) { transaction in
                CardView(transaction: transaction)
            }
        }
    }
}

#Preview {
    SwipeableCardsView(
        model: SwipeableCardsModel(
            transactions: CardViewModel.getExamples()
        )
    )
}
