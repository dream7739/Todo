//
//  TodoInputView.swift
//  Todo
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit
import SnapKit

final class TodoInputView: BaseView {
    let titleTextField = UITextField()
    let seperatorImage = UIImageView()
    let contentTextView = UITextView()
    
    override func configureHierarchy(){
        addSubview(titleTextField)
        addSubview(seperatorImage)
        addSubview(contentTextView)
    }
    
    override func configureLayout(){
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(44)
        }
        
        seperatorImage.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(2)
            make.height.equalTo(1)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(seperatorImage.snp.bottom).offset(2)
            make.height.equalTo(110)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
    
    override func configureUI(){
        layer.cornerRadius = 10
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        titleTextField.placeholder = "제목"
        titleTextField.font = Design.Font.tertiary
        seperatorImage.backgroundColor = .lightGray
        contentTextView.isScrollEnabled = false
        contentTextView.font = Design.Font.tertiary
        contentTextView.backgroundColor = .clear
        contentTextView.textColor = .lightGray
        contentTextView.text = "내용"
        contentTextView.delegate = self
    }
}

extension TodoInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.textColor == .black && textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = "내용"
        }
    }
}
