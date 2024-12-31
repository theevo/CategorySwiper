//
//  SwipeableCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/4/24.
//

import SwiftUI

struct SwipeableCardsView: View {
    @EnvironmentObject var manager: InterfaceManager
    @State private var model: SwipeableCardsModel = SwipeableCardsModel.empty
    @State private var dragState = CGSize.zero
    @State private var showingSheet = false
    @State var cardToEdit: CardViewModel = CardViewModel(transaction: Transaction.exampleDummy)
    
    private let swipeThreshold: CGFloat = 100.0
    
    var body: some View {
        ZStack {
            if model.isEmpty {
                NoTransactionsView()
            } else if model.isDoneSwiping, !showingSheet {
                SwipedAllCardsView()
            }
            else {
                ForEach($model.unswipedCards.reversed()) { card in
                    let isTop = model.isTopCard(card: card.wrappedValue)
                    let isSecond = model.isSecondCard(card: card.wrappedValue)
                    
                    CardView(
                        card: card,
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
                                    if swipeDirection == .left {
                                        cardToEdit = card.wrappedValue
                                        showModal()
                                    }
                                    
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
        .onAppear(perform: {
            Task {
                try await manager.loadData()
                model = SwipeableCardsModel(transactions: manager.transactions)
                
            }
        })
        .sheet(isPresented: $showingSheet) {
            CategoriesSelectorView(
                showingSheet: $showingSheet,
                model: CategoriesSelectorViewModel(
                    categories: manager.categories,
                    card: cardToEdit
                )
            )
            .interactiveDismissDisabled()
        }
    }
    
    func showModal() {
        showingSheet = true
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingSheet: Bool
    @Binding var card: CardViewModel
    
    var body: some View {
        VStack {
            Text(card.merchant)
            Text(card.category)
        }
        Button("Press to dismiss") {
            showingSheet = false
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}

#Preview("5") {
    SwipeableCardsView()
        .environmentObject(InterfaceManager(localMode: true))
}

#Preview("0 Transactions") {
    SwipeableCardsView()
        .environmentObject(InterfaceManager(localMode: true))
}
