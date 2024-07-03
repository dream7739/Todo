//
//  Display.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit

enum Display {
    enum ViewType: String {
        case editTodo = "할 일 편집"
        case addTodo = "새로운 할 일"
    }
    
    enum AddOption: String, CaseIterable {
        case input = ""
        case deadline = "마감일"
        case tag = "태그"
        case priority = "우선 순위"
        case image = "이미지 추가"
    }
    
    enum MainOption: String, CaseIterable {
        case today = "오늘"
        case tobe = "예정"
        case total = "전체"
        case flag = "깃발 표시"
        case complete = "완료됨"
        
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
            }
        }
    }
    
  
}
