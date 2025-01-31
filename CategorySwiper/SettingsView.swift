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
                HStack {
                    if manager.isTokenWorking {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    DebounceSecureField(label: "API Access Token", value: $token) { value in
                        manager.saveBearerToken(value)
                        Task { await manager.validateToken() }
                    }
                    .disabled(true)
                }
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
            Section {
                Button("Remove Token") {
                    token = ""
                    manager.removeToken()
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear() {
            token = manager.getBearerToken()
            Task { await manager.validateToken() }
        }
        .onDisappear() {
            manager.runTaskAndAdvanceState()
        }
    }
}

#Preview("Valid") {
    SettingsView()
        .environmentObject(InterfaceManager(dataSource: .Local))
}

#Preview("Empty") {
    SettingsView()
        .environmentObject(InterfaceManager(dataSource: .Empty))
}
