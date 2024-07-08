//
//  Priority.swift
//  Todo
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit

enum Priority: String, CaseIterable {
    case high = "높음"
    case medium = "보통"
    case row = "낮음"
}

enum MainOption: String, CaseIterable {
    case today = "오늘"
    case tobe = "예정"
    case total = "전체"
    case flag = "깃발 표시"
    case complete = "완료됨"
    case user = "사용자 지정"
    
    var iconImage: UIImage {
        switch self {
        case .today:
            return Design.Image.today
        case .tobe:
            return Design.Image.tobe
        case .total:
            return Design.Image.total
        case .flag:
            return Design.Image.flag
        case .complete:
            return Design.Image.complete
        case .user:
            return Design.Image.like
        }
    }
    
    var iconColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .tobe:
            return .systemRed
        case .total:
            return .gray
        case .flag:
            return .systemOrange
        case .complete:
            return .gray
        case .user:
            return .systemCyan
        }
    }
}

enum SortMenuOption: String {
    case total = "전체"
    case title = "제목순"
    case deadLine = "마감일순"
    case priority = "우선순위순"
    case high = "높음"
    case medium = "보통"
    case row = "낮음"
}
