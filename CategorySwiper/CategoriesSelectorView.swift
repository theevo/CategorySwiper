//
//  CategoriesSelectorView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/21/24.
//

import SwiftUI

struct CategoriesSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingSheet: Bool
    @Binding var model: CategoriesSelectorViewModel
    
    var body: some View {
        HStack {
            Text(model.card.merchant)
            Text(model.card.amount, format: .currency(code: model.card.currency))
        }
        HStack {
            Text("Selected: \(model.selectedCategoryName)")
        }
        Button("Save") {
            showingSheet = false
            model.updateCategory()
            dismiss()
        }
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

struct CategorySelectorPreviewView: View {
    @State var showingSheet: Bool = true
    @State var model: CategoriesSelectorViewModel
    
    var body: some View {
        CategoriesSelectorView(
            showingSheet: $showingSheet,
            model: $model
        )
    }
}

#Preview("Groceries") {
    CategorySelectorPreviewView(
        model: CategoriesSelectorViewModel(
            categories: try! LMLocalInterface().getCategories().categories,
            card: CardViewModel(
                transaction: Transaction.exampleCentralMarket
            )
        )
    )
}

#Preview("Sangha") {
    CategorySelectorPreviewView(model:
        CategoriesSelectorViewModel(
            categories: try! LMLocalInterface().getCategories().categories,
            card: CardViewModel(
                transaction: Transaction.exampleOpenSourceCollective)
        )
    )
}

#Preview("Empty") {
    CategorySelectorPreviewView(model:
        CategoriesSelectorViewModel(
            categories: [],
            card: CardViewModel(
                transaction: Transaction.exampleOpenSourceCollective)
        )
    )
}
