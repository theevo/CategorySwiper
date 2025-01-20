//
//  OSLog+Logger.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/20/25.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    static var subsystem = Bundle.main.bundleIdentifier!

    static let state = Logger(subsystem: subsystem, category: "state")
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
}

struct LogThisAs {
    static func state(_ str: String) {
        Logger.state.info("\(str)")
    }
    
    static func viewCycle(_ str: String) {
        Logger.viewCycle.info("\(str)")
    }
}
