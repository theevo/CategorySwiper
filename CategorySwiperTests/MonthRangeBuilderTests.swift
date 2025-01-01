//
//  MonthRangeBuilderTests.swift
//  CategorySwiperTests
//
//  Created by Tana Vora on 1/1/25.
//

import XCTest
@testable import CategorySwiper

class MonthRangeBuilderTests: XCTestCase {
    func test_1monthAgo() {
        let currentDate = utcDate(from: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate, monthsAgo: 1)
        XCTAssertEqual(sut.first, "1980-05-01")
        XCTAssertEqual(sut.last, "1980-05-31")
    }
    
    func test_2monthsAgo() {
        let currentDate = utcDate(from: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate, monthsAgo: 2)
        XCTAssertEqual(sut.first, "1980-04-01")
        XCTAssertEqual(sut.last, "1980-04-30")
    }
    
    func test_4MonthsAgo_firstDayAndLastDay() {
        let currentDate = utcDate(from: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate, monthsAgo: 4)
        XCTAssertEqual(sut.first, "1980-02-01")
        XCTAssertEqual(sut.last, "1980-02-29")
    }
    
    // MARK: - Helpers
    fileprivate func utcDate(from str: String) -> Date {
        let formatter = DateFormatter.inUTCTimeZone()
        guard let date = formatter.date(from: str) else { fatalError() } // TODO: - this can be optional
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
