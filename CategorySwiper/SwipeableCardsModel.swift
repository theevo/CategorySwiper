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
    
    init(cards: [CardViewModel]) {
        self.originalCards = cards
        self.unswipedCards = cards
        self.swipedCards = []
    }
    
    convenience init(transactions: [Transaction]) {
        let cards = transactions.map { CardViewModel(transaction: $0) }
        self.init(cards: cards)
    }
    
    var isEmpty: Bool {
        originalCards.isEmpty
    }
    
    var isDoneSwiping: Bool {
        unswipedCards.isEmpty && swipedCards.notEmpty
    }
    
    func isTopCard(card: CardViewModel) -> Bool {
        card == unswipedCards.first
    }
    
    func isSecondCard(card: CardViewModel) -> Bool {
        card == unswipedCards.dropFirst().first
    }
    
    func removeTopCard() {
        if !unswipedCards.isEmpty {
            guard let card = unswipedCards.first else { return }
            unswipedCards.removeFirst()
            swipedCards.append(card)
            print("\(card.merchant) was moved to swipedCards")
        }
    }
    
    func updateTopCardSwipeDirection(_ direction: CardViewModel.SwipeDirection) {
        if !unswipedCards.isEmpty {
            var card = unswipedCards[0]
            card.swipeDirection = direction
            applyAction(card: card)
        }
    }
    
    func reset() {
        unswipedCards = originalCards
        swipedCards = []
    }
    
    private func applyAction(card: CardViewModel) {
        switch card.swipeDirection {
        case .right:
//            _ = try? LMLocalInterface().update(transaction: transaction, newStatus: .cleared)
            print("\(card.merchant) has been cleared")
        case .left:
            print("\(card.merchant) was swiped left.")
        case .none:
            print("this card has not been swiped. no action taken.")
        }
    }
}

extension SwipeableCardsModel {
    public static var empty: SwipeableCardsModel = SwipeableCardsModel(cards: [])
}
