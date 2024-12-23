//
//  CategoriesSelectorViewModel.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/24/24.
//

import Foundation

class CategoriesSelectorViewModel: ObservableObject {
    var categories: [Category]
    @Published var selectedCategory: Category?
    @Published var card: CardViewModel
    
    var selectedCategoryName: String {
        if let selectedCategory = selectedCategory,
           let groupId = selectedCategory.group_id,
           let parent = categories.first(where: { $0.id == groupId }) {
            return parent.name + " ~ " + selectedCategory.name
        }
        return selectedCategory?.name ?? "<no category>"
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
