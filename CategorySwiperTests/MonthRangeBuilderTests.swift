//
//  MonthRangeBuilderTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 1/1/25.
//

import XCTest
@testable import CategorySwiper

class MonthRangeBuilderTests: XCTestCase {
    func test_initWithDate_yieldsCorrectString() {
        let currentDate = utcDate(from: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate)
        XCTAssertEqual(sut.clock.currentDay.format(date: .short), "6/5/80")
    }
    
    func test_1monthAgo() {
        let currentDate = utcDate(from: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate)
        let previousMonth = sut.monthsAgo(1)
        XCTAssertEqual(previousMonth.month, 5)
    }
    
    // MARK: - Helpers
    fileprivate func utcDate(from str: String) -> Date {
        let formatter = DateFormatter.inUTCTimeZone()
        guard let date = formatter.date(from: str) else { fatalError() }
        return date
    }
}

extension DateFormatter {
    public static func inUTCTimeZone(dateFormat: String = "yyyy-MM-dd") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = dateFormat
        return formatter
    }
}
