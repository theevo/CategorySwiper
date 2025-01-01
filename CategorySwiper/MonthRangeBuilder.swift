//
//  MonthRangeBuilder.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/1/25.
//

import Foundation
import Time

struct MonthRangeBuilder {
    var clock: any RegionalClock
    
    init(currentDate: Date? = nil) {
        if let currentDate = currentDate {
            self.clock = Clocks.custom(startingFrom: Instant(date: currentDate))
        } else {
            self.clock = Clocks.system
        }
    }
    
    public func monthsAgo(_ months: UInt) -> Fixed<Month> {
        return clock.previousMonth
    }
}
