//
//  SwipedAllCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import SwiftUI

struct SwipedAllCardsView: View {
    @EnvironmentObject var manager: InterfaceManager
    @ObservedObject var progressModel: UpdateProgressViewModel
    
    var body: some View {
        Form {
            Section {
                UpdateProgressView(model: progressModel)
            } footer: {
                if progressModel.allDone {
                    Text("\(progressModel.itemCount) transactions updated")
                }
            }
        }
        .onAppear {
            manager.runTaskAndAdvanceState()
        }
    }
}

#Preview {
    SwipedAllCardsView(
        progressModel: UpdateProgressViewModel.example
    )
    .environmentObject(InterfaceManager(dataSource: .Empty))
}

#Preview("Scroll") {
    SwipedAllCardsView(
        progressModel: UpdateProgressViewModel.example18
    )
    .environmentObject(InterfaceManager(dataSource: .Empty))
}
