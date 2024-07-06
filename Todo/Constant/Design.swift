//
//  Design.swift
//  Todo
//
//  Created by 홍정민 on 7/3/24.
//

import UIKit

enum Design {
    enum Image {
        static let today = UIImage(systemName: "14.square")!
        static let tobe = UIImage(systemName: "calendar")!
        static let total = UIImage(systemName: "tray.fill")!
        static let flag = UIImage(systemName: "flag.fill")!
        static let complete = UIImage(systemName: "checkmark")!
        static let sort = UIImage(systemName: "ellipsis.circle")!
        static let pin = UIImage(systemName: "pin.fill")!
        static let calendar = UIImage(systemName: "calendar")!
        static let plus =  UIImage(systemName: "plus.circle.fill")!
        static let circle = UIImage(systemName: "circle")!
        static let circleFill = UIImage(systemName: "circle.fill")!
    }
    
    enum Font {
        static let heavy = UIFont.systemFont(ofSize: 25, weight: .heavy)
        static let primary = UIFont.systemFont(ofSize: 17, weight: .bold)
        static let secondary = UIFont.systemFont(ofSize: 14)
        static let tertiary = UIFont.systemFont(ofSize: 13)
    }
}
