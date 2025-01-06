//
//  UpdateProgressView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/6/25.
//

import SwiftUI
import Time

class CountdownTimer {
    var timeLeft: UInt
    var isDone: Bool = false
    
    init(seconds timeLeft: UInt = 5) {
        print("Timer will have \(timeLeft) seconds")
        self.timeLeft = timeLeft
    }
    
    convenience init(randomUpTo: UInt) {
        let random = UInt.random(in: 1...randomUpTo)
        print("RANDOM picked: \(random) seconds from \(randomUpTo)")
        self.init(seconds: random)
    }
    
    func start() async throws -> Bool {
        for try await _ in Clocks.system.strike(every: Second.self).asyncValues {
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                isDone = true
                return true
            }
        }
        return false
    }
}

class UpdateProgressViewModel: ObservableObject {
    @Published var items: [ProgressItem]
    
    init(items: [ProgressItem]) {
        self.items = items
    }
    
    func startActions() {
        for item in items {
            print("started action of \(item.name)")
            Task {
                let result = try await item.action()
                setDone(for: item, isDone: result)
            }
        }
    }
    
    func setDone(for item: ProgressItem, isDone: Bool) {
        let index = items.firstIndex { $0.id == item.id }
        guard let index = index else { return }
        
        var newItem = item
        print("\(newItem.name) isDone set to: \(isDone)")
        newItem.isDone = isDone
        items[index] = newItem
    }
}

struct ProgressItem: Identifiable {
    internal let id: UUID = UUID()
    var isDone: Bool = false
    let name: String
    let action: () async throws -> Bool
    
    init(name: String, action: @escaping () async throws -> Bool) {
        self.name = name
        self.action = action
    }
    
    init(name: String, randomTimerUpTo: UInt) {
        self.name = name
        self.action = {
            let timer = CountdownTimer(randomUpTo: randomTimerUpTo)
            return try await timer.start()
        }
    }
}

struct UpdateProgressView: View {
    @StateObject var model: UpdateProgressViewModel
    
    var body: some View {
        
        ForEach(model.items) { item in
            HStack {
                if !item.isDone {
                    ProgressView()
                } else {
                    Text("✅")
                }
                Text(item.name)
            }
        }
        .onAppear {
            print("😄 appeared!")
            model.startActions()
        }
    }
}

#Preview("Random") {
    UpdateProgressView(
        model: UpdateProgressViewModel(
            items: [
                .init(name: "Central Market",
                      randomTimerUpTo: 6
                     ),
                .init(name: "Timemore -> Gifts",
                      randomTimerUpTo: 6
                     )
            ]
            )
    )
}

#Preview("1 second") {
    UpdateProgressView(
        model: UpdateProgressViewModel(
            items: [
                .init(name: "My Apartment -> Home",
                      action: {
                          let timer = CountdownTimer(seconds: 1)
                          return try await timer.start()
                      }
                     )
            ]
            )
    )
}
