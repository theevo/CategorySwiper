//
//  MonthRangeBuilder.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/1/25.
//

import Foundation
import Time

struct MonthRangeBuilder {
    public var first: String
    public var last: String
    
    init(currentDate: Date? = nil, monthsAgo months: UInt) {
        var clock: any RegionalClock
        if let currentDate = currentDate {
            clock = Clocks.custom(startingFrom: Instant(date: currentDate))
        } else {
            clock = Clocks.system
        }
        
        var month = clock.currentMonth
        
        for _ in 0..<months {
            month = month.previous
        }
        
        self.first = month.firstAndLastDay.first
        self.last = month.firstAndLastDay.last
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
