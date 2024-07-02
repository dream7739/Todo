//
//  TodoListTableViewCell.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit

class TodoListTableViewCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let deadlineLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(deadlineLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        contentLabel.font = .systemFont(ofSize: 14)
        deadlineLabel.font = .systemFont(ofSize: 13)
    }
}
