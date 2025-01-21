//
//  SettingsView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/20/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var manager: InterfaceManager
    @State var token: String = ""
    
    var body: some View {
        Form {
            Section(content: {
                TextField("Please paste access token here.", text: $token)
                PasteButton(payloadType: String.self) { strings in
                    guard let first = strings.first else { return }
                    token = first
                }
                .buttonBorderShape(.roundedRectangle)
            }, header: {
                Text("LunchMoney Access Token")
            }, footer: {
                Text("The LunchMoney Access Token allows this app to read data from your LunchMoney account in order to make changes like changing the category of a transaction. Tap the link below to get your token.")
            })
            Section {
                Link("Get Token from My LunchMoney", destination: URL(string: "https://my.lunchmoney.app/developers")!)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
