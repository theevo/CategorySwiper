//
//  CategorySwiperApp.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/5/24.
//

import SwiftUI

@main
struct CategorySwiperApp: App {
    var manager = InterfaceManager()
    
    var body: some Scene {
        WindowGroup {
            StatesView()
                .environmentObject(manager)
        }
    }
}
