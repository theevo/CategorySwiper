//
//  Category.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/20/24.
//

import Foundation

struct Category: Decodable, Identifiable {
    var id: Int
    var name: String
    var is_income: Bool
    var is_group: Bool
    var children: [Category]?
}

struct CategoryResponseWrapper: Decodable {
    var categories: [Category]
}

extension Category {
    static let exampleGroceries = Category(
        id: 909221,
        name: "Groceries",
        is_income: false,
        is_group: false,
        children: nil
    )
    static let exampleMusic = Category(
        id: 909224,
        name: "Music",
        is_income: false,
        is_group: false,
        children: nil
    )
}

extension Category: Hashable { }
