//
//  MonthRangeBuilder.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/1/25.
//

import Foundation
import Time

struct MonthRangeBuilder {
    private var clock: any RegionalClock
    
    init(currentDate: Date? = nil) {
        if let currentDate = currentDate {
            self.clock = Clocks.custom(startingFrom: Instant(date: currentDate))
        } else {
            self.clock = Clocks.system
        }
    }
    
    public func monthsAgo(_ months: UInt) -> Fixed<Month> {
        var month = clock.currentMonth
        
        for _ in 0..<months {
            month = month.previous
        }
        
        return month
    }
}

extension Fixed<Month> {
    public var firstAndLastDay: (first: String, last: String) {
        let first = self.firstDay.formatISO8601
        let last = self.lastDay.formatISO8601
        return (first, last)
    }
}

extension Fixed<Day> {
    public var formatISO8601: String {
        let year = self.format(year: .naturalDigits)
        let month = self.format(month: .twoDigits)
        let day = self.format(day: .twoDigits)
        return "\(year)-\(month)-\(day)"
    }
}
