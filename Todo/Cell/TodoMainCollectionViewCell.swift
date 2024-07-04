//
//  TodoMainCollectionViewCell.swift
//  Todo
//
//  Created by 홍정민 on 7/3/24.
//

import UIKit
import SnapKit

final class TodoMainCollectionViewCell: BaseCollectionViewCell {
    let displayView = UIView()
    let iconImage = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        displayView.layer.cornerRadius = 10
        displayView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        titleLabel.font = .systemFont(ofSize: 14)
        countLabel.font = .systemFont(ofSize: 25, weight: .heavy)
        iconImage.layer.cornerRadius = 15
        iconImage.tintColor = .white
        iconImage.contentMode = .center
    }
    
    override func configureHierarchy() {
        contentView.addSubview(displayView)
        displayView.addSubview(iconImage)
        displayView.addSubview(titleLabel)
        displayView.addSubview(countLabel)
    }
    
    override func configureLayout() {
        displayView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        iconImage.snp.makeConstraints { make in
            make.top.leading.equalTo(displayView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(30)
            make.height.equalTo(33)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(8)
            make.leading.equalTo(iconImage)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(displayView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureUI() {
        iconImage.image = UIImage(systemName: "person.badge.plus")
    }
}
