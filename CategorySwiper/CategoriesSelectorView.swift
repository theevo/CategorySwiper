//
//  CategoriesSelectorView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/21/24.
//

import SwiftUI

struct CategoriesSelectorView: View {
    @ObservedObject var model: CategoriesSelectorViewModel
    
    var body: some View {
        HStack {
            Text(model.card.merchant)
            Text(model.card.amount, format: .currency(code: model.card.currency))
        }
        HStack {
            Text("Selected: \(model.selectedCategoryName)")
        }
        Button("Save") { }
        Form {
            Picker("Select Category", selection: $model.selectedCategory) {
                ForEach(model.categories, id: \.self) { category in
                    if let children = category.children {
                        ForEach(children) { child in
                            Text("\(category.name) ~ " + child.name).tag(child)
                        }
                    } else {
                        Text(category.name).tag(category)
                    }
                }
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview("Groceries") {
    CategoriesSelectorView(model:
        CategoriesSelectorViewModel(
            categories: try! LMLocalInterface().getCategories().categories,
            card: CardViewModel(transaction: Transaction.exampleCentralMarket)
        )
    )
}

#Preview("Sangha") {
    CategoriesSelectorView(model:
        CategoriesSelectorViewModel(
            categories: try! LMLocalInterface().getCategories().categories,
            card: CardViewModel(transaction: Transaction.exampleOpenSourceCollective)
        )
    )
}

#Preview("Empty") {
    CategoriesSelectorView(model:
        CategoriesSelectorViewModel(
            categories: [],
            card: CardViewModel(transaction: Transaction.exampleOpenSourceCollective)
        )
    )
}
