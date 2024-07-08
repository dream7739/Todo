//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import PhotosUI
import SnapKit

final class AddTodoViewController: BaseViewController {
    
    private let todoInputView = TodoInputView()
    private let tableView = UITableView(frame: .zero)
    
    private let repository = RealmRepository()
    var viewType = Display.ViewType.addTodo
    var image: UIImage?
    var item: Todo!
    var model = TodoModel(title: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item {
            model.title = item.title
            model.content = item.content
            model.deadLine = item.deadLine
            model.hashTag = item.hashTag
            model.priority = item.priority
            
            todoInputView.titleTextField.text = model.title
            
            if let content = model.content, !content.isEmpty {
                todoInputView.contentTextView.text = content
                todoInputView.contentTextView.textColor = .black
            }
            
            if let image = loadImageToDocument(filename: "\(item.id)"){
                self.image = image
            }
        }else{
            item = Todo()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(todoInputView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        todoInputView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(170)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(todoInputView.snp.bottom).offset(3)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = viewType.rawValue
        navigationItem.largeTitleDisplayMode = .never
        
        switch viewType {
        case .editTodo:
            let add = UIBarButtonItem(
                title: "저장",
                style: .plain,
                target: self,
                action: #selector(saveButtonClicked)
            )
            navigationItem.rightBarButtonItem = add
        case .addTodo:
            let cancel = UIBarButtonItem(
                title: "취소",
                style: .plain,
                target: self,
                action: #selector(cancelButtonClicked)
            )
            
            let add = UIBarButtonItem(
                title: "추가",
                style: .plain,
                target: self,
                action: #selector(saveButtonClicked)
            )
            
            navigationItem.leftBarButtonItem = cancel
            navigationItem.rightBarButtonItem = add
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        todoInputView.titleTextField.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoAddTableViewCell.self, forCellReuseIdentifier: TodoAddTableViewCell.identifier)
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    

    
}

extension AddTodoViewController {
    enum AddOption: String, CaseIterable {
        case deadline = "마감일"
        case tag = "태그"
        case priority = "우선 순위"
        case image = "이미지 추가"
    }

    
    @objc
    private func cancelButtonClicked(){
        switch viewType {
        case .editTodo:
            navigationController?.popViewController(animated: true)
        case .addTodo:
            dismiss(animated: true)
        }
    }
    
    @objc
    private func saveButtonClicked(){
        model.title = todoInputView.titleTextField.text!.trimmingCharacters(in: .whitespaces)
        model.content = todoInputView.contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let image {
            saveImageToDocument(image: image, filename: "\(item.id)")
        }
        
        switch viewType {
        case .editTodo:
            repository.editTodo(item, model)
            NotificationCenter.default.post(
                name: NSNotification.Name.saveTodo,
                object: nil,
                userInfo: nil
            )
            navigationController?.popViewController(animated: true)
        case .addTodo:
            repository.addTodo(item, model)
            NotificationCenter.default.post(
                name: NSNotification.Name.saveTodo,
                object: nil,
                userInfo: nil
            )
            dismiss(animated: true)
        }
        
    }
    
    @objc
    private func titleTextFieldChanged(sender: UITextField){
        guard let title = sender.text?.trimmingCharacters(in: .whitespaces), title.isEmpty else{
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoAddTableViewCell.identifier, for: indexPath) as! TodoAddTableViewCell
        
        cell.titleLabel.text = AddOption.allCases[indexPath.row].rawValue
        
        if let deadLine = model.deadLine, indexPath.row == 0 {
            cell.detailLabel.text = deadLine.formattedString()
        }
        
        if let hashTag = model.hashTag, indexPath.row == 1 {
            cell.detailLabel.text = hashTag
        }
        
        if let pirority = model.priority, indexPath.row == 2 {
            cell.detailLabel.text = pirority
        }
        
        if let image, indexPath.row == 3 {
            cell.selectedImage.isHidden = false
            cell.selectedImage.image = image
        }else{
            cell.selectedImage.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        switch indexPath.row {
        case 0:
            let todoDateVC = TodoDateViewController()
            todoDateVC.dateSender = { date in
                self.model.deadLine = date
                tableView.reloadData()
            }
            navigationController?.pushViewController(todoDateVC, animated: true)
        case 1:
            let todoTagVC = TodoTagViewController()
            todoTagVC.tagSender = { tag in
                self.model.hashTag = tag
                tableView.reloadData()
            }
            if let hashTag = model.hashTag {
                todoTagVC.editHashTag = hashTag
            }
            navigationController?.pushViewController(todoTagVC, animated: true)
        case 2:
            let todoPriorityVC = TodoPriorityViewController()
            todoPriorityVC.prioritySender = { priority in
                if let priority {
                    self.model.priority = priority
                    tableView.reloadData()
                }
            }
            navigationController?.pushViewController(todoPriorityVC, animated: true)
        case 3:
            var configuration = PHPickerConfiguration()
            configuration.filter = .any(of: [.images, .screenshots])
            configuration.selectionLimit = 1
            let photoPicker = PHPickerViewController(configuration: configuration)
            photoPicker.delegate = self
            present(photoPicker, animated: true)
        default:
            return
        }
    }
}

extension AddTodoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.image = image as? UIImage
                    self.tableView.reloadData()
                }
            }
        }
    }
}
