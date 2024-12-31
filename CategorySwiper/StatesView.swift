//
//  StatesView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/31/24.
//

import SwiftUI

enum AppStates: String {
    case Fetching
    case FetchEmpty
    case Swiping
    case Done
}

struct StatesView: View {
    @EnvironmentObject var manager: InterfaceManager
    @State var appState: AppStates = .Fetching
    
    var body: some View {
        VStack {
            switch appState {
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
            Task {
                if appState == .Fetching {
                    try await manager.loadData()
                    if manager.transactions.isEmpty {
                        appState = .FetchEmpty
                    } else {
                        appState = .Swiping
                    }
                }
            }
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
