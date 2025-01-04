//
//  LocalTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 11/5/24.
//

import XCTest
@testable import CategorySwiper

@MainActor
final class LocalTests: XCTestCase {
    
    func test_InterfaceManager_returns_nonEmptyTransactionsArray() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        try await manager.getTransactions()
        XCTAssertTrue(manager.transactions.notEmpty)
    }
    
    func test_InterfaceManager_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        try await manager.getTransactions(showUnclearedOnly: true)
        XCTAssertEqual(manager.transactions.count, manager.uncleared.count)
    }
    
    func test_LocalInterface_request5_get5Transactions() async throws {
        let interface = LMLocalInterface()
        let transactions = try interface.loadTransactions(limit: 5)
        XCTAssertEqual(transactions.count, 5)
    }
    
    func test_InterfaceManager_getCategories_containsApplesCategory() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        try await manager.getCategories()
        XCTAssertTrue(manager.categories.notEmpty)
        
        let category = manager.categories.first {
            $0.name.contains("Apple")
        }
        XCTAssertEqual(category?.name, "Apples")
    }
    
    func test_InterfaceManager_updateTransactionCategory_whenNewCategoryIsDifferent_returnsTrue() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        let transaction = Transaction.exampleCentralMarket
        
        let result = try await manager.update(transaction: transaction, newCategory: Category.exampleMusic)
        XCTAssertTrue(result)
    }
    
    func test_InterfaceManager_updateTransactionCategory_whenNewCategoryIsSame_returnsFalse() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        let transaction = Transaction.exampleCentralMarket
        
        let result = try await manager.update(transaction: transaction, newCategory: Category.exampleGas)
        XCTAssertFalse(result)
    }
    
    func test_whenTransactionsEmpty_thenCardsModel_doneSwipingIsFalse() {
        let manager = InterfaceManager(dataSource: .Empty)
        XCTAssertFalse(manager.cardsModel.isDoneSwiping)
    }
    
    func test_whenTransactionsNotEmpty_thenCardsModel_doneSwipingIsTrue() {
        let manager = InterfaceManager(dataSource: .Local)
        for card in manager.cardsModel.unswipedCards {
            manager.cardsModel.updateTopCardSwipeDirection(.right)
            manager.cardsModel.removeTopCard()
        }
        XCTAssertTrue(manager.cardsModel.isDoneSwiping)
    }
    
    func test_whenSwipeAllCardsRight_thenAllSwipedCards_haveDirectionRight() {
        let manager = InterfaceManager(dataSource: .Local)
        
        let cardCount = manager.cardsModel.unswipedCards.count
        
        for _ in manager.cardsModel.unswipedCards {
            manager.cardsModel.updateTopCardSwipeDirection(.right)
            manager.cardsModel.removeTopCard()
        }
        
        XCTAssertEqual(manager.cardsModel.swipedCards.count, cardCount, "swipedCards count should be equal to unswipedCards count before swiping")
        
        for card in manager.cardsModel.swipedCards {
            XCTAssertEqual(card.swipeDirection, .right)
        }
    }
    
    func test_whenSwipeAllCardsLeft_thenAllSwipedCards_haveDirectionLeft() {
        let manager = InterfaceManager(dataSource: .Local)
        
        let cardCount = manager.cardsModel.unswipedCards.count
        
        for _ in manager.cardsModel.unswipedCards {
            manager.cardsModel.updateTopCardSwipeDirection(.left)
            let card = manager.cardsModel.removeTopCard()!
            manager.cardsModel.cardHasNewCategory(card: card)
        }
        
        XCTAssertEqual(manager.cardsModel.swipedCards.count, cardCount, "swipedCards count should be equal to unswipedCards count before swiping")

        for card in manager.cardsModel.swipedCards {
            XCTAssertEqual(card.swipeDirection, .left)
        }
    }
}
