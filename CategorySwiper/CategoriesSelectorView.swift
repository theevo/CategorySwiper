//
//  CategoriesSelectorView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/21/24.
//

import SwiftUI

struct CategoriesSelectorView: View {
    var categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories) { category in
                Text(category.name)
            }
        }
    }
}

#Preview {
    CategoriesSelectorView(categories: try! LMLocalInterface().getCategories().categories)
}
