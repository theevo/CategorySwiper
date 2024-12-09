//
//  Data+jsonFlatString.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/9/24.
//

import Foundation

extension Data {
    var jsonFlatString: String {
        String(data: self, encoding: .utf8) ?? "<invalid json>"
    }
}
