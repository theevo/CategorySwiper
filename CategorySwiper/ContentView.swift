//
//  ContentView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Some Transaction $1.00")
            Text("Cateogory: Food")
            HStack {
                Button("Edit", systemImage: "pencil.circle.fill") {
                    print("✍️ edit category")
                }
                Button("Approve", systemImage: "checkmark.seal.fill") {
                    print("✅ mark reviewed")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
