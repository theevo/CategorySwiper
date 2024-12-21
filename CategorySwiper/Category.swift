//
//  Category.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/20/24.
//

import Foundation

struct Category: Decodable {
    var id: Int
    var name: String
    var is_income: Bool
    var is_group: Bool
    var children: [Category]?
}

struct CategoryResponseWrapper: Decodable {
    var categories: [Category]
}
