//
//  DebounceSecureField.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/22/25.
//

import SwiftUI
import Combine

struct DebounceSecureField: View {
    @State var publisher = PassthroughSubject<String, Never>()
    
    @State var label: String
    @Binding var value: String
    var valueChanged: ((_ value: String) -> Void)?
    
    @State var debounceSeconds = 1.110
    
    var body: some View {
        SecureField(label, text: $value)
            .disableAutocorrection(true)
            .onChange(of: value) { _, value in
                publisher.send(value)
            }
            .onReceive(
                publisher.debounce(
                    for: .seconds(debounceSeconds),
                    scheduler: DispatchQueue.main
                )
            ) { value in
                if let valueChanged = valueChanged {
                    valueChanged(value)
                }
            }
    }
}

struct DebounceSecureFieldPreviewView: View {
    var label: String
    @State var str: String = ""
    
    var body: some View {
        DebounceSecureField(
            label: label,
            value: $str) { value in
                print("DebounceSecureField received value: \(value)")
            }
    }
}

#Preview {
    DebounceSecureFieldPreviewView(label: "Example")
}
