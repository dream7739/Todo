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
    let completeButton = UIButton()
    let stackView = UIStackView()
    let subStackView = UIStackView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let deadlineLabel = UILabel()
    let tagLabel = UILabel()
    let imageStackView = UIStackView()
    let pinImage = UIImageView()
    let flagImage = UIImageView()
    
    var delegate: CompletDelegate?
    var indexPath: IndexPath?
    
    var isCompleteClicked = false {
        didSet {
            if isCompleteClicked {
                completeButton.setImage(Design.Image.circleFill, for: .normal)
            }else{
                completeButton.setImage(Design.Image.circle, for: .normal)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = ""
        tagLabel.text = ""
    }
    
    override func configureHierarchy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(stackView)
        contentView.addSubview(imageStackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(subStackView)
        subStackView.addArrangedSubview(deadlineLabel)
        subStackView.addArrangedSubview(tagLabel)
        imageStackView.addArrangedSubview(flagImage)
        imageStackView.addArrangedSubview(pinImage)
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
            make.trailing.equalTo(imageStackView.snp.leading).inset(8)
        }
      
        deadlineLabel.snp.makeConstraints { make in
            make.width.equalTo(78)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        pinImage.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        
        flagImage.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
    }
    
    override func configureUI() {
        completeButton.setImage(Design.Image.circle, for: .normal)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        subStackView.axis = .horizontal
        subStackView.spacing = 2
        
        imageStackView.axis = .horizontal
        imageStackView.spacing = 2
        
        titleLabel.font = Design.Font.primary
        contentLabel.font = Design.Font.secondary
        deadlineLabel.font = Design.Font.tertiary
        tagLabel.font = Design.Font.tertiary
        tagLabel.textColor = .systemBlue
        
        pinImage.image = Design.Image.pin
        pinImage.tintColor = .systemGray
        flagImage.image = Design.Image.flag
        flagImage.tintColor = .systemOrange
    }
    

    func configureData(_ data: Todo){
        isCompleteClicked = data.isComplete
       
        var priorityText = ""
        var folderName = ""
        
        if let folder = data.folder.first  {
            folderName = "[\(folder.name)]"
        }
        
        if let priority = data.priority {
            if priority == "높음" {
                priorityText = "⭐️⭐️⭐️ "
            }else if priority == "보통"{
                priorityText = "⭐️⭐️"
            }else{
                priorityText = "⭐️"
            }
        }
        
        titleLabel.text = priorityText + folderName + data.title
        
        if let content = data.content, !content.isEmpty {
            contentLabel.text = content
        }

        if let deadLine = data.deadLine {
            deadlineLabel.isHidden = false
            deadlineLabel.text = deadLine.formattedString()
        }else{
            deadlineLabel.isHidden = true
        }
                
        if let tag = data.hashTag, !tag.trimmingCharacters(in: .whitespaces).isEmpty {
            tagLabel.text = "#" + tag
        }
        
        pinImage.isHidden = data.isFavorite ? false : true
        flagImage.isHidden = data.isFlaged ? false : true
    }
    
    @objc func completeButtonClicked(){
        guard let indexPath else { return }
        delegate?.completeButtonClicked(indexPath: indexPath)
    }
}
