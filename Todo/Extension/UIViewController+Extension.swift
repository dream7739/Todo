//
//  UIViewController+Extension.swift
//  Todo
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit

extension UIViewController {
    func showAlert(_ t: String?, _ content: String?, _ actionTitle: String?, completion: @escaping ((UIAlertAction) -> Void)){
        let alert = UIAlertController(title: t, message: content, preferredStyle: .alert)
        let confirm = UIAlertAction(title: actionTitle, style: .default, handler: completion)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}
