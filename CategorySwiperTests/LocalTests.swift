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
        try await manager.getUnclearedTransactions()
        XCTAssertTrue(manager.transactions.notEmpty)
    }
    
    func test_InterfaceManager_requestUnclearedTransactionsOnly_allResponseStatusesAreUncleared() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        try await manager.getUnclearedTransactions()
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
        
        let result = try await manager.updateAndClear(transaction: transaction, newCategory: Category.exampleMusic)
        XCTAssertTrue(result)
    }
    
    func test_InterfaceManager_updateTransactionCategory_whenNewCategoryIsSame_returnsFalse() async throws {
        let manager = InterfaceManager(dataSource: .Local)
        let transaction = Transaction.exampleCentralMarket
        
        let result = try await manager.updateAndClear(transaction: transaction, newCategory: Category.exampleGas)
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
            let cardToEdit = manager.cardsModel.removeTopCard()!
            let model = CategoriesSelectorViewModel(categories: manager.categories, card: cardToEdit)
            
            manager.cardsModel.set(card: model.card, to: nil)
        }
        
        XCTAssertEqual(manager.cardsModel.swipedCards.count, cardCount, "swipedCards count should be equal to unswipedCards count before swiping")

        for card in manager.cardsModel.swipedCards {
            XCTAssertEqual(card.swipeDirection, .left)
        }
    }
    
    func test_whenCategoryChanges_thenNewCategoryIsSet() {
        let manager = InterfaceManager(dataSource: .Local)
        let cardToEdit = manager.cardsModel.unswipedCards.first!
        
        // mimic SwipeableCardsView
        manager.cardsModel.updateTopCardSwipeDirection(.left)
        var model = CategoriesSelectorViewModel(categories: manager.categories, card: cardToEdit)
        manager.cardsModel.removeTopCard()
        
        // mimic CategoriesSelectorView
        let newCategory = manager.categories.first!
        model.selectedCategory = newCategory
        manager.cardsModel.set(card: model.card, to: model.selectedCategory)
        
        let cardToCheck = manager.cardsModel.swipedCards.first!
        XCTAssertEqual(cardToCheck.newCategory, newCategory)
    }
    
    func test_given1card_whenLastCardCategoryIsEdited_isDoneSwipingIsFALSE() {
        let manager = InterfaceManager(dataSource: .Local, limit: 1)
        
        let cardToEdit = manager.cardsModel.unswipedCards.first!
        
        // swipe Left
        manager.cardsModel.updateTopCardSwipeDirection(.left)
        let _ = CategoriesSelectorViewModel(categories: manager.categories, card: cardToEdit)
        manager.cardsModel.removeTopCard()
        
        XCTAssertFalse(manager.cardsModel.isDoneSwiping)
    }
    
    func test_given2cards_whenLastCardCategoryIsEdited_isDoneSwipingIsFALSE() {
        let manager = InterfaceManager(dataSource: .Local, limit: 2)
        
        // swipe Right on first card
        manager.cardsModel.updateTopCardSwipeDirection(.right)
        manager.cardsModel.removeTopCard()
        
        let cardToEdit = manager.cardsModel.unswipedCards.first!
        
        // swipe Left on second card
        manager.cardsModel.updateTopCardSwipeDirection(.left)
        let _ = CategoriesSelectorViewModel(categories: manager.categories, card: cardToEdit)
        manager.cardsModel.removeTopCard()
        
        XCTAssertFalse(manager.cardsModel.isDoneSwiping)
    }
    
    func test_given1card_afterLastCardCategoryIsEdited_thenStateIsDONE() async {
        let manager = InterfaceManager(dataSource: .Local, limit: 1)
        
        XCTAssertEqual(manager.appState, .Swiping)
        
        let cardToEdit = manager.cardsModel.unswipedCards.first!
        
        // swipe Left
        manager.cardsModel.updateTopCardSwipeDirection(.left)
        var model = CategoriesSelectorViewModel(categories: manager.categories, card: cardToEdit)
        manager.cardsModel.removeTopCard()
        
        // save new category
        let newCategory = manager.categories.first!
        model.selectedCategory = newCategory
        manager.cardsModel.set(card: model.card, to: model.selectedCategory)

        // we've returned to SwipeableCardsView
        let runTaskAndAdvanceState = Task {
            if manager.cardsModel.isDoneSwiping {
                manager.runTaskAndAdvanceState()
            }
        }
        
        await runTaskAndAdvanceState.value
        
        XCTAssertEqual(manager.appState, .Done)
    }
}
