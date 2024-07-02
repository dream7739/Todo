//
//  ReusableProtocol.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
