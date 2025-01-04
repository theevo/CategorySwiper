//
//  SwipeableCardsModel.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import Foundation

struct SwipeableCardsModel {
    private var originalCards: [CardViewModel]
    var unswipedCards: [CardViewModel]
    var swipedCards: [CardViewModel]
    
    init(cards: [CardViewModel]) {
        self.originalCards = cards
        self.unswipedCards = cards
        self.swipedCards = []
    }
    
    init(transactions: [Transaction]) {
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
    
    @discardableResult mutating func removeTopCard() -> CardViewModel? {
        guard let card = unswipedCards.first else { return nil }
        
        unswipedCards.removeFirst()
        
        if card.swipeDirection == .right {
            clearStatus(card: card)
        }
        
        return card
    }
    
    mutating func updateTopCardSwipeDirection(_ direction: CardViewModel.SwipeDirection) {
        guard var first = unswipedCards.first else { return }
        
        first.swipeDirection = direction
        unswipedCards[0] = first
    }
    
    mutating func cardHasNewCategory(card: CardViewModel) {
        clearStatus(card: card)
    }
    
    mutating func reset() {
        unswipedCards = originalCards
        swipedCards = []
    }
    
    private mutating func clearStatus(card: CardViewModel) {
        var card = card
        card.transaction.status = .cleared
        swipedCards.append(card)
    }
}

extension SwipeableCardsModel {
    public static var empty: SwipeableCardsModel = SwipeableCardsModel(cards: [])
}
