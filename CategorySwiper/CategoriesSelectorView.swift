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
                if let children = category.children {
                    ForEach(children) { child in
                        Text("    " + child.name)
                    }
                }
            }
        }
    }
}

#Preview {
    CategoriesSelectorView(categories: try! LMLocalInterface().getCategories().categories)
}
