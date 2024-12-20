//
//  SwipeableCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/4/24.
//

import SwiftUI

struct SwipeableCardsView: View {
    @ObservedObject var model: SwipeableCardsModel
    @State private var dragState = CGSize.zero
    
    private let swipeThreshold: CGFloat = 100.0
    
    var body: some View {
        if model.isEmpty {
            NoTransactionsView()
        } else if model.isDoneSwiping {
            SwipedAllCardsView()
        }
        else {
            ZStack {
                ForEach($model.unswipedCards.reversed()) { card in
                    let isTop = model.isTopCard(card: card.wrappedValue)
                    let isSecond = model.isSecondCard(card: card.wrappedValue)
                    
                    CardView(
                        transaction: card,
                        isTop: isTop,
                        isSecond: isSecond,
                        dragOffset: dragState
                    )
                    .offset(x: isTop ? dragState.width : 0)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.dragState = gesture.translation
                                //                    self.cardRotation = Double(gesture.translation.width) / rotationFactor
                            }
                            .onEnded { value in
                                if abs(self.dragState.width) > swipeThreshold {
                                    let swipeDirection: CardViewModel.SwipeDirection = self.dragState.width > 0 ? .right : .left
                                    model.updateTopCardSwipeDirection(swipeDirection)
                                    
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        self.dragState.width = self.dragState.width > 0 ? 1000 : -1000
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.model.removeTopCard()
                                        self.dragState = .zero
                                    }
                                } else {
                                    withAnimation(.bouncy(extraBounce:0.21)) {
                                        self.dragState = .zero
                                        //                            self.cardRotation = 0
                                    }
                                }
                            }
                    )
                }
            }
        }
    }
}

#Preview("5") {
    SwipeableCardsView(
        model: SwipeableCardsModel(
            transactions: CardViewModel.getExamples(shuffled: true)
        )
    )
}

#Preview("0 Transactions") {
    SwipeableCardsView(
        model: SwipeableCardsModel(
            transactions: []
        )
    )
}
