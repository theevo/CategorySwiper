//
//  SwipeableCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/4/24.
//

import SwiftUI

struct SwipeableCardsView: View {
    @EnvironmentObject var manager: InterfaceManager
    @State private var dragState = CGSize.zero
    @State private var showingSheet = false
    @State var categoriesModel: CategoriesSelectorViewModel = CategoriesSelectorViewModel.dummy
    
    private let swipeThreshold: CGFloat = 100.0
    
    var body: some View {
        ZStack {
            ForEach($manager.cardsModel.unswipedCards.reversed()) { card in
                let isTop = manager.cardsModel.isTopCard(card: card.wrappedValue)
                let isSecond = manager.cardsModel.isSecondCard(card: card.wrappedValue)
                
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
                                manager.cardsModel.updateTopCardSwipeDirection(swipeDirection)
                                if swipeDirection == .left {
                                    let cardToEdit = card.wrappedValue
                                    categoriesModel = CategoriesSelectorViewModel(categories: manager.categories, card: cardToEdit)
                                    showModal()
                                }
                                
                                withAnimation(.easeOut(duration: 0.5)) {
                                    self.dragState.width = self.dragState.width > 0 ? 1000 : -1000
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.manager.cardsModel.removeTopCard()
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
        .sheet(isPresented: $showingSheet) {
            CategoriesSelectorView(
                showingSheet: $showingSheet,
                model: $categoriesModel
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

#Preview("Some") {
    SwipeableCardsView()
        .environmentObject(InterfaceManager(dataSource: .Local))
}

#Preview("0 Transactions") {
    SwipeableCardsView()
        .environmentObject(InterfaceManager(dataSource: .Empty))
}
