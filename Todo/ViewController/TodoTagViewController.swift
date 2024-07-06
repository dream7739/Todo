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
    
    var tagSender: ((String) -> Void)?
    var editHashTag: String?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tagSender?(tagTextField.text!)
    }
    
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
      
        if let editHashTag {
            tagTextField.text = editHashTag
        }
    }
}
