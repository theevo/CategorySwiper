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
        // if not found in categories, return the card's category name and indicate that it wasn't found
        guard let _ = CategoriesSelectorViewModel.find(id: card.category_id, in: categories) else {
            return (card.category_name ?? "") + " ❌🔎"
        }
        
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
    }
    
    init(categories: [Category], card: CardViewModel) {
        let category = CategoriesSelectorViewModel.find(id: card.category_id, in: categories)
                
        self.init(
            categories: categories,
            selectedCategory: category,
            card: card)
    }
    
    func updateCategory() {
        guard let selectedCategory = selectedCategory else { return }
        
        let wasUpdated = LMLocalInterface().update(transaction: card.transaction, newCategory: selectedCategory)
        wasUpdated ? print("Updated to \(selectedCategory.name)") : print("No change was made.")
    }
}

extension CategoriesSelectorViewModel {
    static func find(id: Int?, in categories: [Category]) -> Category? {
        guard let id = id else { return nil }
        
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
    
    static let dummy = CategoriesSelectorViewModel(categories: [], card: CardViewModel.dummy)
}
