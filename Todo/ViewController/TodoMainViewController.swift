//
//  TodoMainViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/3/24.
//

import UIKit
import SnapKit

final class TodoMainViewController: BaseViewController {
    lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let addTodoButton = UIButton()
    private let addListButton = UIButton()
    
    private var countList: [Int] = []
    private let repository = RealmRepository()

    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let inset: CGFloat = 10
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(
            width: (view.bounds.width - spacing - inset * 2) / 2,
            height: (view.bounds.height - spacing * 7 - inset * 2) / 8
        )
        return layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countList = repository.fetchCountAll()
        collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(addTodoButton)
        view.addSubview(addListButton)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        addTodoButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        addListButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureUI() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let calendar = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonClicked))
        navigationItem.rightBarButtonItem = calendar
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TodoMainCollectionViewCell.self,
            forCellWithReuseIdentifier: TodoMainCollectionViewCell.identifier
        )
        
        var todoConfig = UIButton.Configuration.plain()
        todoConfig.image = UIImage(systemName: "plus.circle.fill")
        todoConfig.imagePadding = 4
        todoConfig.title = "새로운 할 일"
        addTodoButton.configuration = todoConfig
        
        var listConfig = UIButton.Configuration.plain()
        listConfig.title = "목록 추가"
        addListButton.configuration = listConfig
        
        addTodoButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
        addListButton.addTarget(self, action: #selector(addListButtonClicked), for: .touchUpInside)
    }
}

extension TodoMainViewController {
    enum MainOption: String, CaseIterable {
        case today = "오늘"
        case tobe = "예정"
        case total = "전체"
        case flag = "깃발 표시"
        case complete = "완료됨"
        
        var iconImage: UIImage {
            switch self {
            case .today:
                return Design.Image.today
            case .tobe:
                return Design.Image.tobe
            case .total:
                return Design.Image.total
            case .flag:
                return Design.Image.flag
            case .complete:
                return Design.Image.complete
            }
        }
        
        var iconColor: UIColor {
            switch self {
            case .today:
                return .systemBlue
            case .tobe:
                return .systemRed
            case .total:
                return .gray
            case .flag:
                return .systemOrange
            case .complete:
                return .gray
            }
        }
    }
    
    @objc
    private func calendarButtonClicked(){
        let calendarVC = TodoCalendarViewController()
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc
    private func addTodoButtonClicked(){
        let addTodoVC = UINavigationController(rootViewController: AddTodoViewController())
        addTodoVC.modalPresentationStyle = .fullScreen
        present(addTodoVC, animated: true)
    }
    
    @objc
    private func addListButtonClicked(){
        print(#function)

    }
}

extension TodoMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoMainCollectionViewCell.identifier, for: indexPath) as? TodoMainCollectionViewCell else { return UICollectionViewCell() }
        let data = MainOption.allCases[indexPath.item]
        cell.titleLabel.text = data.rawValue
        cell.iconImage.image = data.iconImage
        cell.iconImage.backgroundColor = data.iconColor
        cell.countLabel.text = countList[indexPath.item].formatted()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let todoListVC = TodoListViewController()
        todoListVC.option = MainOption.allCases[indexPath.item]
        navigationController?.pushViewController(todoListVC, animated: true)
    }
}
