//
//  DateFormatter+Extensions.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.04.2024.
//

import Foundation

extension DateFormatter {
    static let ramDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
