//
//  TodoTagViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/3/24.
//

import UIKit
import SnapKit
import Toast

final class TodoTagViewController: BaseViewController {
    private let tagTextField = UITextField()
    var delegate: TagTextSendDelegate?
    var editTagText: String?

    override func configureHierarchy() {
        view.addSubview(tagTextField)
    }
    
    override func configureLayout() {
        tagTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        tagTextField.placeholder = "태그를 입력해주세요"
        let save = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveButtonClicked)
        )
        navigationItem.rightBarButtonItem = save
        
        if let editTagText {
            tagTextField.text = editTagText
        }
    }
}

extension TodoTagViewController {
    @objc
    func saveButtonClicked(){
        guard let text = tagTextField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else{
            view.makeToast("태그를 입력해주세요")
            return
        }
        
        guard text.count <= 5 else {
            view.makeToast("태그는 5글자까지 가능합니다")
            return
        }
        
        delegate?.tagTextSend(text)
        navigationController?.popViewController(animated: true)
    }
}

