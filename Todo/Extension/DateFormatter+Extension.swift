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
    
    func startOfDay() -> Self {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        return start
    }
    
    func endOfDay() -> Self {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()   
        return end
    }
    
    func tomorrow() -> Self {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        return tomorrow
    }
}
