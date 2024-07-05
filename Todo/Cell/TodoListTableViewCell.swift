//
//  TodoListTableViewCell.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import SnapKit

protocol CompletDelegate {
    func completeButtonClicked(indexPath : IndexPath)
}

final class TodoListTableViewCell: BaseTableViewCell {
    let stackView = UIStackView()
    let subStackView = UIStackView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let deadlineLabel = UILabel()
    let tagLabel = UILabel()
    let completeButton = UIButton()
    var delegate: CompletDelegate?
    var indexPath: IndexPath?
    
    var isCompleteClicked = false {
        didSet {
            if isCompleteClicked {
                completeButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            }else{
                completeButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(subStackView)
        subStackView.addArrangedSubview(deadlineLabel)
        subStackView.addArrangedSubview(tagLabel)
    }
    
    override func configureLayout() {
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
      
        deadlineLabel.snp.makeConstraints { make in
            make.width.equalTo(78)
        }
    }
    
    override func configureUI() {
        completeButton.setImage(UIImage(systemName: "circle"), for: .normal)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
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
    
    @objc func completeButtonClicked(){
        guard let indexPath else { return }
        delegate?.completeButtonClicked(indexPath: indexPath)
    }
}
