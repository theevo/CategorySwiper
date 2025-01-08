//
//  SwipedAllCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import SwiftUI

struct SwipedAllCardsView: View {
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
    }
}

#Preview {
    SwipedAllCardsView(
        progressModel: UpdateProgressViewModel.example
    )
}

#Preview("Scroll") {
    SwipedAllCardsView(
        progressModel: UpdateProgressViewModel.example18
    )
}
