//
//  TodoCalendarViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/5/24.
//

import UIKit
import FSCalendar
import RealmSwift
import SnapKit

final class TodoCalendarViewController: BaseViewController {
    private let calendar = FSCalendar()
    private let tableView = UITableView()
    
    private var list: Results<Todo>!
    private let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "캘린더"
    }
    
    override func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        calendar.delegate = self
        calendar.dataSource = self
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent))
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        list = repository.fetchList(calendar.today ?? Date())
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
    }
    
}

extension TodoCalendarViewController {
    @objc
    func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            calendar.scope = .week
        } else if swipe.direction == .down {
            calendar.scope = .month
        }
    }
}

extension TodoCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        list = repository.fetchList(date)
        tableView.reloadData()
    }
    
}

extension TodoCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
        let data = list[indexPath.row]
        cell.configureData(data)
        return cell
    }
}

