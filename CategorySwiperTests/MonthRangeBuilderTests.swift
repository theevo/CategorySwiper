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
        let currentDate = dateFromISO(string: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate, monthsAgo: 1)
        XCTAssertEqual(sut.first, "1980-05-01")
        XCTAssertEqual(sut.last, "1980-05-31")
    }
    
    func test_2monthsAgo() {
        let currentDate = dateFromISO(string: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate, monthsAgo: 2)
        XCTAssertEqual(sut.first, "1980-04-01")
        XCTAssertEqual(sut.last, "1980-04-30")
    }
    
    func test_4MonthsAgo_firstDayAndLastDay() {
        let currentDate = dateFromISO(string: "1980-06-05")
        let sut = MonthRangeBuilder(currentDate: currentDate, monthsAgo: 4)
        XCTAssertEqual(sut.first, "1980-02-01")
        XCTAssertEqual(sut.last, "1980-02-29")
    }
    
    func test_precedingMonthsBeforeThisMonth() {
        let currentDate = dateFromISO(string: "1978-11-26")
        let sut = MonthRangeBuilder(currentDate: currentDate, precedingMonthsBeforeThisMonth: 3)
        XCTAssertEqual(sut.first, "1978-08-01")
        XCTAssertEqual(sut.last, "1978-10-31")
    }
    
    // MARK: - Helpers
    fileprivate func dateFromISO(string: String) -> Date? {
        let formatter = DateFormatter.inUTCTimeZone()
        return formatter.date(from: string)
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
