//
//  UpdateProgressView.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/6/25.
//

import SwiftUI
import Time

class CountdownTimer: ObservableObject {
    @Published var timeLeft: UInt
    @Published var isDone: Bool = false
    
    init(seconds timeLeft: UInt = 5) {
        self.timeLeft = timeLeft
        Task {
            try await start()
        }
    }
    
    convenience init(randomUpTo timeLeft: UInt) {
        let random = UInt.random(in: 1...timeLeft)
        print("starting with \(random) seconds")
        self.init(seconds: random)
    }
    
    func start() async throws {
        for try await _ in Clocks.system.strike(every: Second.self).asyncValues {
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                isDone = true
                return
            }
        }
    }
}

struct UpdateProgressView: View {
    @StateObject var countdownTimer: CountdownTimer = CountdownTimer()
    
    var body: some View {
        HStack {
            if !countdownTimer.isDone {
                ProgressView()
            } else {
                Text("✅")
            }
            Text("\(countdownTimer.timeLeft)")
            Text("Timemore -> Gifts")
        }
    }
}

#Preview("Random") {
    UpdateProgressView(
        countdownTimer: CountdownTimer.init(randomUpTo: 10)
    )
}

#Preview("1 second") {
    UpdateProgressView(
        countdownTimer: CountdownTimer.init(seconds: 1)
    )
}
