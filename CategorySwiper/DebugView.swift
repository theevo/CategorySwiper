//
//  DebugView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/20/25.
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject var manager: InterfaceManager
    var message: String
    
    var body: some View {
        NavigationStack {
            Text(message)
            .toolbar {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                }
            }
        }
        
    }
}

#Preview {
    DebugView(message: "👾 Server returned HTTP status code 401.")
}
