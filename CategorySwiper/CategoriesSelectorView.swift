//
//  CategoriesSelectorView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/21/24.
//

import SwiftUI

struct CategoriesSelectorView: View {
    var categories: [Category]
    @State var selectedCategory: Category?
    
    var body: some View {
        NavigationView {
            List(selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category.name)
                }
            }
            .navigationTitle("Select Category")
//            .toolbar { EditButton() }
        }
        //                if let children = category.children {
        //                    ForEach(children) { child in
        //                        Button("    " + child.name, action: { selectedCategory = child })
        //                    }
        //                }
        
        
        
        //        List {
//            ForEach(categories) { category in
//                Text(category.name)
//                if let children = category.children {
//                    ForEach(children) { child in
//                        Text("    " + child.name)
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    CategoriesSelectorView(
        categories: try! LMLocalInterface().getCategories().categories,
        selectedCategory: try! LMLocalInterface().getCategories().categories[2]
    )
}
