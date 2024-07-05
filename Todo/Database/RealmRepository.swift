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
    
}
