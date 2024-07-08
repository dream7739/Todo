//
//  TodoPriorityViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/3/24.
//

import UIKit
import SnapKit

final class TodoPriorityViewController: BaseViewController {
    private lazy var segment = UISegmentedControl()
    
    var priority: String?
    var prioritySender: ((String?) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prioritySender?(priority)
    }
    
    override func configureHierarchy() {
        view.addSubview(segment)
    }
    
    override func configureLayout() {
        segment.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        segment.insertSegment(withTitle: Priority.allCases[0].rawValue, at: 0, animated: true)
        segment.insertSegment(withTitle: Priority.allCases[1].rawValue, at: 1, animated: true)
        segment.insertSegment(withTitle: Priority.allCases[2].rawValue, at: 2, animated: true)
        segment.addTarget(self, action: #selector(segmentItemClicked), for: .valueChanged)
    }
}

extension TodoPriorityViewController {
    @objc
    private func segmentItemClicked(sender: UISegmentedControl){
        priority = Priority.allCases[sender.selectedSegmentIndex].rawValue
    }
}
