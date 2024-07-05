//
//  RealmProtocol.swift
//  Todo
//
//  Created by 홍정민 on 7/5/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol {
    func fetchList() -> Results<Todo>
    func addTodo(_ item: Todo)
    func editTodo(_ before: Todo, _ after: TodoModel)
    func deleteTodo(_ item: Todo)
}
