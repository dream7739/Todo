//
//  DateFormatter+Extension.swift
//  Todo
//
//  Created by 홍정민 on 7/6/24.
//

import Foundation

enum DateFormat: String {
    case yearMonthDate = "yyyy.MM.dd."
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yearMonthDate.rawValue
        return dateFormatter
    }()
}

extension Date {
    func formattedString() -> String {
        return DateFormatter.dateFormatter.string(from: self)
    }
    
    func today() -> Self {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: self)
        return start
    }
    
    func tomorrow() -> Self {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        return tomorrow
    }
}
