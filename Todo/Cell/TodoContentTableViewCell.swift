//
//  TodoContentCell.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit

final class TodoContentTableViewCell: BaseTableViewCell {
    let contentTextView = UITextView()
    
    override func configureHierarchy() {
        contentView.addSubview(contentTextView)
    }
    
    override func configureLayout() {
        contentTextView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
    }
    
}
