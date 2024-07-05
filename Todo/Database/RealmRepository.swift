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
    
    func fetchList() -> Results<Todo>{
        return realm.objects(Todo.self)
    }
    
    func fetchList(_ option: Display.MainOption) -> Results<Todo>{
        let list = realm.objects(Todo.self)
        
        switch option {
        case .today:
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: Date())
            let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()
            let predicate = NSPredicate(
                format: "deadLine >= %@ && deadLine <= %@",
                start as NSDate,
                end as NSDate
            )
            return list.filter(predicate).sorted(byKeyPath: "isFavorite", ascending: false)
        case .tobe:
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let start = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
            let predicate = NSPredicate(format: "deadLine >= %@", start as NSDate)
            return list.filter(predicate).sorted(byKeyPath: "isFavorite", ascending: false)
        case .total:
            return list.sorted(byKeyPath: "isFavorite", ascending: false)
        case .flag:
            return list.where{ $0.isFlaged }.sorted(byKeyPath: "isFavorite", ascending: false)
        case .complete:
            return list.where{ $0.isComplete }.sorted(byKeyPath: "isFavorite", ascending: false)
        }
    }

    func fetchList(_ date: Date) -> Results<Todo>{
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = NSPredicate(
            format: "deadLine >= %@ && deadLine <= %@",
            start as NSDate,
            end as NSDate
        )
        return realm.objects(Todo.self).filter(predicate).sorted(byKeyPath: "isFavorite", ascending: false)
    }
    
    func fetchCount(_ option: Display.MainOption) -> Int{
        return fetchList(option).count
    }
    
    func fetchCountAll() -> [Int] {
        var result = Array(repeating: 0, count: 5)
        for idx in 0..<Display.MainOption.allCases.count {
            let option = Display.MainOption.allCases[idx]
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
    
}

