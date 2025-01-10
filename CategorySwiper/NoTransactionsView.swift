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
    }
}

#Preview {
    NoTransactionsView()
        .environmentObject(InterfaceManager(dataSource: .Empty))
}
