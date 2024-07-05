//
//  RealmProtocol.swift
//  Todo
//
//  Created by 홍정민 on 7/5/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol {
    func addTodo(_ item: Todo, _ model: TodoModel)
    func fetchList() -> Results<Todo>
    func fetchList(_ option: Display.MainOption) -> Results<Todo>
    func fetchList(_ date: Date) -> Results<Todo>
    func fetchCount(_ option: Display.MainOption) -> Int
    func fetchCountAll() -> [Int]
    func editTodo(_ item: Todo, _ model: TodoModel)
    func editIsComplete(_ item: Todo, isComplete: Bool)
    func editIsFavorite(_ item: Todo, isFavorite: Bool)
    func editIsFlaged(_ item: Todo, isFlaged: Bool)
    func deleteTodo(_ item: Todo)
}
