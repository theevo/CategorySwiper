//
//  MonthRangeBuilder.swift
//  CategorySwiper
//
//  Created by Tana Vora on 1/1/25.
//

import Foundation
import Time

struct MonthRangeBuilder {
    init() {
        let systemClock = Clocks.system
        let thisMonth = systemClock.currentMonth
        let previousMonth = systemClock.previousMonth
        
        let firstDay = previousMonth.firstDay
        let lastDay = previousMonth.lastDay
        
        let firstDayFormatted = firstDay.format(year: .naturalDigits, month: .twoDigits, day: .twoDigits)
        let lastDayFormatted = lastDay.format(year: .naturalDigits, month: .twoDigits, day: .twoDigits)
        
        print(firstDayFormatted)
        print(lastDayFormatted)
    }
}
