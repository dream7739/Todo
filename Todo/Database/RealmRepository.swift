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
        return realm.objects(Todo.self)
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
    
    func deleteTodo(_ item: Todo){
        do{
            try realm.write {
                realm.delete(item)
            }
        }catch{
            print("delete Realm Item Failed")
        }
    }
    
    //1. 오늘
    //2. 예정
    //3. 전체
    //4. 깃발표시(컬럼추가 필요)
    //5. 완료됨(컬럼추가 필요)
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

