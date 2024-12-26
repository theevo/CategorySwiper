//
//  InterfaceManager.swift
//  CategorySwiper
//
//  Created by Tana Vora on 12/26/24.
//

import Foundation

class InterfaceManager: ObservableObject {
    private let interface: LunchMoneyInterface
    var categories: [Category] = []
    
    init(localMode: Bool = false) {
        self.interface = localMode ? LMLocalInterface() : LMNetworkInterface()
    }
    
    public func getCategories() async throws {
        let response = try await interface.getCategories()
        self.categories = response.categories
    }
}
