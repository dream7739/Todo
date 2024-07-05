//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit
import PhotosUI
import SnapKit


protocol TagTextSendDelegate: AnyObject {
    func tagTextSend(_ text: String)
}

final class AddTodoViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let repository = RealmRepository()
    var viewType = Display.ViewType.addTodo
    var image: UIImage?
    var item: Todo?
    var model = TodoModel(title: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receivePriority),
            name: NSNotification.Name("sendPriority"),
            object: nil
        )
        
        guard let item else { return }
        
        if let image = loadImageToDocument(filename: "\(item.id)"){
            self.image = image
        }
        
        model.title = item.title
        model.content = item.content
        model.deadLine = item.deadLine
        model.hashTag = item.hashTag
        model.priority = item.priority
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = viewType.rawValue
        navigationItem.largeTitleDisplayMode = .never
        
        switch viewType {
        case .editTodo:
            let add = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
            navigationItem.rightBarButtonItem = add
        case .addTodo:
            let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
            
            let add = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(saveButtonClicked))
            
            navigationItem.leftBarButtonItem = cancel
            navigationItem.rightBarButtonItem = add
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.register(TodoTitleTableViewCell.self, forCellReuseIdentifier: TodoTitleTableViewCell.identifier)
        tableView.register(TodoContentTableViewCell.self, forCellReuseIdentifier: TodoContentTableViewCell.identifier)
    }
    
}

extension AddTodoViewController {
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
        guard let item else { return }
        
        if let image {
            saveImageToDocument(image: image, filename: "\(item.id)")
        }
        
        let titleItem = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TodoTitleTableViewCell
        let contentItem = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TodoContentTableViewCell
        model.title = titleItem.titleTextField.text!.trimmingCharacters(in: .whitespaces)
        model.content = contentItem.contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch viewType {
        case .editTodo:
            repository.editTodo(item, model)
            navigationController?.popViewController(animated: true)
        case .addTodo:
            repository.addTodo(item)
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
    
    @objc
    private func receivePriority(notification: NSNotification){
        guard let priority = notification.userInfo?["priority"] as? String else { return }
        model.priority = priority
        tableView.reloadData()
    }
    
}

extension AddTodoViewController: TagTextSendDelegate {
    func tagTextSend(_ tagText: String) {
        model.hashTag = tagText
        tableView.reloadData()
    }
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1{
            return 130
        }
        
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Display.AddOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (1...4).contains(indexPath.section){
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "todoCell")
            cell.textLabel?.text = Display.AddOption.allCases[indexPath.section].rawValue
            cell.accessoryType = .disclosureIndicator
            
            if let deadLine = model.deadLine, indexPath.section == 1 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                cell.detailTextLabel?.text = dateFormatter.string(from: deadLine)
            }
            
            if let hashTag = model.hashTag, indexPath.section == 2 {
                cell.detailTextLabel?.text = hashTag
            }
            
            if let pirority = model.priority, indexPath.section == 3 {
                cell.detailTextLabel?.text = pirority
            }
            
            if let image, indexPath.section == 4{
                cell.accessoryView = UIImageView(image: image)
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            }
            
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoTitleTableViewCell.identifier, for: indexPath) as! TodoTitleTableViewCell
                
                if !model.title.isEmpty {
                    cell.titleTextField.text = model.title
                }
                
                cell.selectionStyle = .none
                cell.titleTextField.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoContentTableViewCell.identifier, for: indexPath) as! TodoContentTableViewCell
                
                if let content = model.content, !content.isEmpty {
                    cell.contentTextView.text = content
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    //1: 날짜, 2. 태그, 3: 우선순위, 4: 이미지
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let todoDateVC = TodoDateViewController()
            todoDateVC.dateSender = { date in
                self.model.deadLine = date
                tableView.reloadData()
            }
            navigationController?.pushViewController(todoDateVC, animated: true)
        case 2:
            let todoTagVC = TodoTagViewController()
            todoTagVC.delegate = self
            if let hashTag = model.hashTag {
                todoTagVC.editHashTag = hashTag
            }
            navigationController?.pushViewController(todoTagVC, animated: true)
        case 3:
            let todoPriorityVC = TodoPriorityViewController()
            navigationController?.pushViewController(todoPriorityVC, animated: true)
        case 4:
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
