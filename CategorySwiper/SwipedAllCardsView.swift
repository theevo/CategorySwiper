//
//  SwipedAllCardsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/5/24.
//

import SwiftUI

struct SwipedAllCardsView: View {
    var items: [ProgressItem]
    
    var body: some View {
        VStack {
            UpdateProgressView(model: UpdateProgressViewModel(items: items))
            Text("All done!")
            Text("X transactions updated on MM/DD/YY")
            Text("Time for a treat! 🍧")
        }
    }
}

#Preview {
    SwipedAllCardsView(
        items: UpdateProgressViewModel.example.items
    )
}
