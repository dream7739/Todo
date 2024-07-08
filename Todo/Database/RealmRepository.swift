//
//  RealmRepository.swift
//  Todo
//
//  Created by 홍정민 on 7/4/24.
//

import Foundation
import RealmSwift

class RealmRepository: RealmProtocol {
    private let realm = try! Realm()
    
    func addFolder(){
        
        let folderName = ["운동", "공부", "독서", "약속"]
        
        for name in folderName {
            let folder = Folder(name: name)
            do{
                try realm.write {
                    realm.add(folder)
                }
            }catch{
                print("Add Realm Item Failed")
            }
        }
    }
    
    func addTodo(_ item: Todo, _ model: TodoModel){
        do{
            try realm.write {
                item.title = model.title
                item.content = model.content
                item.deadLine = model.deadLine
                item.hashTag = model.hashTag
                item.priority = model.priority
                realm.add(item)
            }
        }catch{
            print("Add Realm Item Failed")
        }
    }
    
    func addFolderTodo(_ item: Todo, _ model: TodoModel, _ folder: Folder){
        do{
            try realm.write {
                item.title = model.title
                item.content = model.content
                item.deadLine = model.deadLine
                item.hashTag = model.hashTag
                item.priority = model.priority
                folder.detail.append(item)
            }
        }catch{
            print("Add Realm Item Failed")
        }
    }
    
    func fetchFolder() -> Results<Folder>{
        return realm.objects(Folder.self)
    }
    
    func fetchList() -> Results<Todo>{
        return realm.objects(Todo.self).sorted(by: [Descripter.favoriteDesc])
    }
    
    func fetchList(_ option: MainOption) -> Results<Todo>{
        let list = realm.objects(Todo.self)
        
        switch option {
        case .today:
            let date = Date()
            let start = date.today()
            let end = date.tomorrow()
            let predicate = NSPredicate(
                format: "deadLine >= %@ && deadLine < %@",
                start as NSDate,
                end as NSDate
            )
            return list.filter(predicate).sorted(by: [Descripter.favoriteDesc])
        case .tobe:
            let date = Date()
            let start = date.tomorrow()
            let predicate = NSPredicate(format: "deadLine >= %@", start as NSDate)
            return list.filter(predicate).sorted(by: [Descripter.favoriteDesc])
        case .total:
            return list.sorted(by: [Descripter.favoriteDesc])
        case .flag:
            return list.where{ $0.isFlaged }.sorted(by: [Descripter.favoriteDesc])
        case .complete:
            return list.where{ $0.isComplete }.sorted(by: [Descripter.favoriteDesc])
        case .user:
            return list
        }
    }
    
    func fetchList(_ option: MainOption, _ sortOption: SortOption) -> Results<Todo>{
        let list = realm.objects(Todo.self)

        switch sortOption {
        case .total:
            return list.sorted(by: sortOption.descriptor)
        case .title, .deadLine:
            return list.sorted(by: sortOption.descriptor)
        case .priority(let priority):
            return list.where { $0.priority == priority.rawValue}.sorted(by: sortOption.descriptor)
        }
    }
    
    func fetchList(_ date: Date) -> Results<Todo>{
        let start = date.today()
        let end = date.tomorrow()
        let predicate = NSPredicate(
            format: "deadLine >= %@ && deadLine < %@",
            start as NSDate,
            end as NSDate
        )
        return realm.objects(Todo.self).filter(predicate).sorted(by: [Descripter.favoriteDesc])
    }
    
    func fetchList(_ keyword: String) -> Results<Todo>{
        return realm.objects(Todo.self).where {
            $0.title.contains(keyword, options: .caseInsensitive)
        }.sorted(by: [Descripter.favoriteDesc])
    }
    
    func fetchCount(_ option: MainOption) -> Int{
        return fetchList(option).count
    }
    
    func fetchFolderCount() -> Int {
        let folder = realm.objects(Folder.self)
        var result = 0
        for item in folder {
            result += item.detail.count
        }
        return result
    }
    
    func fetchCountAll() -> [Int] {
        var result = Array(repeating: 0, count: 6)
        for idx in 0..<MainOption.allCases.count {
            let option = MainOption.allCases[idx]
            result[idx] = fetchCount(option)
        }
        return result
    }
    
    func editTodo(_ item: Todo, _ model: TodoModel){
        do{
            try realm.write {
                item.title = model.title
                item.content = model.content
                item.hashTag = model.hashTag
                item.priority = model.priority
                item.deadLine = model.deadLine
            }
        }catch{
            print("Edit Realm Item Failed")
        }
    }
    
    func editIsComplete(_ item: Todo, isComplete: Bool){
        do {
            try realm.write {
                item.isComplete = isComplete
            }
        }catch{
            print("Edit Realm isComplete Failed")
            
        }
    }
    
    func editIsFavorite(_ item: Todo, isFavorite: Bool){
        do {
            try realm.write {
                item.isFavorite = isFavorite
            }
        }catch{
            print("Edit Realm isFavorite Failed")
            
        }
    }
    
    func editIsFlaged(_ item: Todo, isFlaged: Bool){
        do {
            try realm.write {
                item.isFlaged = isFlaged
            }
        }catch{
            print("Edit Realm isFlaged Failed")
            
        }
    }
    
    func deleteTodo(_ item: Todo){
        do{
            try realm.write {
                realm.delete(item)
            }
        }catch{
            print("delete Realm Item Failed")
        }
    }
    
    func detectRealmURL(){
        print(realm.configuration.fileURL ?? "")
    }
    
}

extension RealmRepository{
    typealias SortDescriptor = RealmSwift.SortDescriptor
    
    enum Descripter{
        static let favoriteDesc = SortDescriptor(keyPath: "isFavorite", ascending: false)
        static let titleAsc = SortDescriptor(keyPath: "title", ascending: true)
        static let deadLineAsc = SortDescriptor(keyPath: "deadLine", ascending: true)
    }
    
    enum SortOption {
        case total
        case title
        case deadLine
        case priority(_ priority: Priority)
        
        var descriptor: [SortDescriptor] {
            switch self {
            case .total, .priority:
                return [Descripter.favoriteDesc]
            case .title:
                return [Descripter.favoriteDesc,
                        Descripter.titleAsc]
            case .deadLine:
                return [Descripter.favoriteDesc,
                        Descripter.deadLineAsc]
            }
        }
        
    }
}
