//
//  StatesView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/31/24.
//

import SwiftUI

struct StatesView: View {
    @EnvironmentObject var manager: InterfaceManager
    
    var body: some View {
        VStack {
            switch manager.appState {
            case .Fetching:
                ProgressView()
            case .FetchEmpty:
                NoTransactionsView()
            case .Swiping:
                SwipeableCardsView()
            case .Done:
                SwipedAllCardsView()
            }
        }
        .onAppear {
            print("🧐 StatesView appeared")
        }
    }
}

#Preview("Local Data") {
    StatesView()
        .environmentObject(InterfaceManager(dataSource: .Local))
}

#Preview("0") {
    StatesView()
        .environmentObject(InterfaceManager(dataSource: .Empty))
}
