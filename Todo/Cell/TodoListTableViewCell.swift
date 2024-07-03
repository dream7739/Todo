//
//  TodoListTableViewCell.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit

final class TodoListTableViewCell: BaseTableViewCell {
    let stackView = UIStackView()
    let subStackView = UIStackView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let deadlineLabel = UILabel()
    let tagLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(subStackView)
        subStackView.addArrangedSubview(deadlineLabel)
        subStackView.addArrangedSubview(tagLabel)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
      
        deadlineLabel.snp.makeConstraints { make in
            make.width.equalTo(78)
        }
    }
    
    override func configureUI() {
        stackView.axis = .vertical
        stackView.spacing = 4
        subStackView.axis = .horizontal
        subStackView.spacing = 2
        
        titleLabel.font = .boldSystemFont(ofSize: 17)
        contentLabel.font = .systemFont(ofSize: 14)
        deadlineLabel.font = .systemFont(ofSize: 13)
        tagLabel.font = .boldSystemFont(ofSize: 13)
        tagLabel.textColor = .systemBlue
    }
}
