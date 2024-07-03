//
//  TodoPriorityViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/3/24.
//

import UIKit
import SnapKit

final class TodoPriorityViewController: BaseViewController {
    private lazy var segment = UISegmentedControl(items: list)
    
    private let list = ["높음", "보통", "낮음"]
    
    override func configureHierarchy() {
        view.addSubview(segment)
    }
    
    override func configureLayout() {
        segment.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        segment.addTarget(self, action: #selector(segmentItemClicked), for: .valueChanged)
    }
}

extension TodoPriorityViewController {
    @objc
    private func segmentItemClicked(sender: UISegmentedControl){
        NotificationCenter.default.post(name: NSNotification.Name("sendPriority"), object: nil, userInfo: ["priority": list[sender.selectedSegmentIndex]])
    }
}
