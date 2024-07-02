//
//  TodoDateViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit

class TodoDateViewController: BaseViewController {
    let picker = UIDatePicker()
    var dateSender: ((Date) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(picker.date)
        dateSender?(picker.date)
    }
    
    
    override func configureHierarchy() {
        view.addSubview(picker)
    }
    
    override func configureLayout() {
        picker.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.minimumDate = Date()
    }
}


