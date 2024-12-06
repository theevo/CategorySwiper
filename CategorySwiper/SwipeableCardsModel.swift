//
//  SwipeableCardsModel.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import Foundation

class SwipeableCardsModel: ObservableObject {
    private var originalCards: [CardViewModel]
    @Published var unswipedCards: [CardViewModel]
    @Published var swipedCards: [CardViewModel]
    
    init(transactions: [CardViewModel]) {
        self.originalCards = transactions
        self.unswipedCards = transactions
        self.swipedCards = []
    }
    
    func isTopCard(card: CardViewModel) -> Bool {
        card == unswipedCards.first
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