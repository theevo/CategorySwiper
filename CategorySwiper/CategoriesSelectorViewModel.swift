//
//  CategoriesSelectorViewModel.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/24/24.
//

import Foundation

struct CategoriesSelectorViewModel {
    var categories: [Category]
    var selectedCategory: Category?
    var card: CardViewModel
    
    var selectedCategoryName: String {
        guard let selectedCategory = selectedCategory else { return "<<Uncategorized>>" }
        
        // if it's in a group, prefix the parent name
        if let groupId = selectedCategory.group_id,
           let parent = categories.first(where: { $0.id == groupId }) {
            return parent.name + " ~ " + selectedCategory.name
        }
        
        return selectedCategory.name
    }
    
    init(categories: [Category], selectedCategory: Category?, card: CardViewModel) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.card = card
        
        print("CategoriesSelectorVM received card: \(card.merchant) with category: \(card.category_name ?? "Uncategorized")")
    }
    
    init(categories: [Category], card: CardViewModel) {
        let category = CategoriesSelectorViewModel.find(card: card, in: categories)
                
        self.init(
            categories: categories,
            selectedCategory: category,
            card: card)
    }
    
    mutating func updateCategory() {
        guard let selectedCategory = selectedCategory else { return }
        
        card.changeCategoryTo(category: selectedCategory)
    }
}

extension CategoriesSelectorViewModel {
    static func find(card: CardViewModel, in categories: [Category]) -> Category? {
        guard let id = card.category_id else { return nil }
        
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
            // if not found in categories, return the card's category name and indicate that it wasn't found
            return placeholderCategoryFor(cardNotFound: card)
        }
    }
    
    static func placeholderCategoryFor(cardNotFound card: CardViewModel) -> Category {
        Category(
            id: card.category_id ?? 0,
            name: (card.category_name ?? "") + " ❌🔎",
            is_income: card.transaction.is_income,
            is_group: false,
            group_id: nil,
            children: nil
        )
    }
    
    static let dummy = CategoriesSelectorViewModel(categories: [], card: CardViewModel.dummy)
}
