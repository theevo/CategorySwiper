//
//  CategorySwiperApp.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/5/24.
//

import SwiftUI

@main
struct CategorySwiperApp: App {
    @StateObject var manager = InterfaceManager()
    
    private var isProduction: Bool {
        NSClassFromString("XCTestCase") == nil
    }
    
    var body: some Scene {
        WindowGroup {
            if isProduction {
                StatesView()
                    .environmentObject(manager)
            }
        }
    }
}
