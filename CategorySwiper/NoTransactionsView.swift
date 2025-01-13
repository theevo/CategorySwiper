//
//  NoTransactionsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/6/24.
//

import SwiftUI

struct NoTransactionsView: View {
    @EnvironmentObject var manager: InterfaceManager
    
    var body: some View {
        Text("No uncleared transactions this month.")
            .onAppear {
                manager.runTaskAndAdvanceState()
            }
            .sheet(isPresented: $manager.didFindMoreTransactions) {
                OldTransactionsFoundView(dateOfOldest: manager.oldestTransactionDate)
            }
    }
}

#Preview {
    NoTransactionsView()
        .environmentObject(InterfaceManager(dataSource: .Empty))
}

#Preview("Found Old Transactions") {
    NoTransactionsView()
        .environmentObject(InterfaceManager.previewOldTransactionFound)
}

struct OldTransactionsFoundView: View {
    @EnvironmentObject var manager: InterfaceManager
    var dateOfOldest: String? = "2024-12-12"
    
    var body: some View {
        VStack {
            Text("More transactions found.")
                .font(.headline)
            if let dateOfOldest {
                Text("Oldest: \(dateOfOldest)")
                    .font(.subheadline)
            }
            Button("Go") {
                print("Go button pressed")
                manager.swipeOnOldTransactions()
            }
            .buttonStyle(.borderedProminent)
            .padding(10)
        }
        .presentationDetents([.fraction(0.25), .fraction(0.4)])
        .presentationDragIndicator(.hidden)
    }
}
