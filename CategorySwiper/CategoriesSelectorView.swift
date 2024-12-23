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
        if let groupId = selectedCategory.group_id,
           let parent = categories.first(where: { $0.id == groupId }) {
            return parent.name + " ~ " + selectedCategory.name
        }
        return selectedCategory.name
    }
    
    init(categories: [Category]) {
        self.categories = categories
        
        let lastGroup = categories.last!
        
        if let justice = lastGroup.children?.first(where: { $0.name.contains("Justice") }) {
            self.selectedCategory = justice
        } else {
            self.selectedCategory = categories.first!
        }
        
        print("Selected Category: \(selectedCategoryName)")
    }
    
    init(categories: [Category], selectedCategory: Category) {
        self.categories = categories
        self.selectedCategory = selectedCategory
    }
}

struct CategoriesSelectorView: View {
    @ObservedObject var model: CategoriesSelectorViewModel
    
    var body: some View {
        HStack {
            Text("Selected: \(model.selectedCategoryName)")
            Button("Save") { }
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
