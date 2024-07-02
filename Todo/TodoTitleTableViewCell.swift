//
//  TodoTitleTableViewCell.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit

class TodoTitleTableViewCell: BaseTableViewCell {
    let titleTextField = UITextField()
    
    override func configureHierarchy() {
        contentView.addSubview(titleTextField)
    }
    
    override func configureLayout() {
        titleTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    override func configureUI() {
        titleTextField.placeholder = "제목"
    }
}
