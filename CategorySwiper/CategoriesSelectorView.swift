//
//  CategoriesSelectorView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/21/24.
//

import SwiftUI

class CategoriesSelectorViewModel: ObservableObject {
    var categories: [Category]
    @Published var selectedCategory: Category?
    @Published var card: CardViewModel
    
    var selectedCategoryName: String {
        guard let selectedCategory = selectedCategory,
           let groupId = selectedCategory.group_id,
           let parent = categories.first(where: { $0.id == groupId }) else {
            return "<no category>"
        }
        return parent.name + " ~ " + selectedCategory.name
    }
    
    init(categories: [Category], selectedCategory: Category?, card: CardViewModel) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.card = card
    }
    
    convenience init(categories: [Category], card: CardViewModel) {
        let category = CategoriesSelectorViewModel.find(id: card.category_id, in: categories)
                
        self.init(
            categories: categories,
            selectedCategory: category,
            card: card)
    }
    
    static func find(id: Int?, in categories: [Category]) -> Category? {
        var flattenedCategories = categories
        
        let parents = categories.filter { $0.is_group }
        
        for parent in parents {
            if let children = parent.children {
                flattenedCategories.append(contentsOf: children)
            }
        }
        
        if let foundCategory = flattenedCategories.first(where: { $0.id == id }) {
            return foundCategory
        } else {
            return nil
        }
    }
}

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
