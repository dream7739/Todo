//
//  TodoAddTableViewCell.swift
//  Todo
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit
import SnapKit

class TodoAddTableViewCell: BaseTableViewCell {
    let backView = UIView()
    let titleLabel = UILabel()
    let stackView = UIStackView()
    let detailLabel = UILabel()
    let selectedImage = UIImageView()
    let rightDetailImage = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedImage.image = nil
        detailLabel.text = nil
    }
    override func configureHierarchy() {
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(stackView)
        stackView.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(selectedImage)
        backView.addSubview(rightDetailImage)
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightDetailImage.snp.leading).offset(-10)
        }
        
        selectedImage.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        rightDetailImage.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(15)
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureUI() {
        backView.layer.cornerRadius = 10
        backView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        titleLabel.font = Design.Font.secondary
        stackView.axis = .horizontal
        stackView.spacing = 4
        detailLabel.font = Design.Font.tertiary
        rightDetailImage.image = Design.Image.right
        rightDetailImage.tintColor = .gray
      
    }
}
