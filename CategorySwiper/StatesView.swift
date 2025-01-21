//
//  StatesView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/31/24.
//

import SwiftUI

struct FetchingView: View {
    @EnvironmentObject var manager: InterfaceManager
    
    var body: some View {
        VStack {
            Text("Checking for new transactions...")
            ProgressView()
        }
    }
}

struct StatesView: View {
    @EnvironmentObject var manager: InterfaceManager
    
    var body: some View {
        VStack {
            switch manager.appState {
            case .Fetching:
                FetchingView()
                    .environmentObject(manager)
            case .FetchEmpty:
                NoTransactionsView()
            case .Swiping:
                SwipeableCardsView()
            case .Done:
                SwipedAllCardsView(progressModel: manager.progressModel)
            case .Debug(let message):
                Text(message)
            }
        }
        .onAppear {
            LogThisAs.viewCycle("StatesView appeared")
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
