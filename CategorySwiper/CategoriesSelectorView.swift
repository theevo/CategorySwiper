//
//  CategoriesSelectorView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/21/24.
//

import SwiftUI

class CategoriesSelectorViewModel: ObservableObject {
    var categories: [Category]
    @Published var selectedCategory: Category
    
    var selectedCategoryName: String {
        selectedCategory.name
    }
    
    init(categories: [Category]) {
        self.categories = categories
        self.selectedCategory = categories.randomElement()!
    }
    
    init(categories: [Category], selectedCategory: Category) {
        self.categories = categories
        self.selectedCategory = selectedCategory
    }
}

struct CategoriesSelectorView: View {
    @ObservedObject var model: CategoriesSelectorViewModel
    
    var body: some View {
        Form {
            Picker("Select Category", selection: $model.selectedCategory) {
                ForEach(model.categories, id: \.self) { category in
                    Text(category.name).tag(category)
                }
            }
        }

//        NavigationView {
//            List(selection: $selectedCategory) {
//                ForEach(categories, id: \.self) { category in
//                    Text(category.name)
//                }
//            }
//            .navigationTitle("Select Category")
//            .toolbar { EditButton() }
//        }
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
    CategoriesSelectorView(model:
        CategoriesSelectorViewModel(
            categories: try! LMLocalInterface().getCategories().categories
        )
    )
}
