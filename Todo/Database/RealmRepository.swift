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
    
    func fetchList() -> Results<Todo> {
        return realm.objects(Todo.self).sorted(byKeyPath: "isFavorite", ascending: false)
    }
    
    func addTodo(_ item: Todo){
        do{
            try realm.write {
                realm.add(item)
            }
        }catch{
            print("Add Realm Item Failed")
        }
    }
    
    func editTodo(_ before: Todo, _ after: TodoModel){
        do{
            try realm.write {
                before.title = after.title
                before.content = after.content
                before.hashTag = after.hashTag
                before.priority = after.priority
                before.deadLine = after.deadLine
            }
        }catch{
            print("Edit Realm Item Failed")
        }
    }
    
    func editIsComplete(_ before: Todo, isComplete: Bool){
        do {
            try realm.write {
                before.isComplete = isComplete
            }
        }catch{
            print("Edit Realm isComplete Failed")

        }
    }
    
    func editIsFavorite(_ before: Todo, isFavorite: Bool){
        do {
            try realm.write {
                before.isFavorite = isFavorite
            }
        }catch{
            print("Edit Realm isFavorite Failed")

        }
    }
    
    func editIsFlaged(_ before: Todo, isFlaged: Bool){
        do {
            try realm.write {
                before.isFlaged = isFlaged
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
    

    
    func fetchCount(with option: Display.MainOption) -> Int{
        switch option {
        case .today:
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: Date())
            let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()
            let predicate = NSPredicate(format: "deadLine >= %@ && deadLine <= %@", start as NSDate, end as NSDate)
            return realm.objects(Todo.self).filter(predicate).count
        case .tobe:
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let start = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
            let predicate = NSPredicate(format: "deadLine >= %@", start as NSDate)
            return realm.objects(Todo.self).filter(predicate).count
        case .total:
            return realm.objects(Todo.self).count
        case .flag:
            return 0
        case .complete:
            return 0
        }
    }
}

