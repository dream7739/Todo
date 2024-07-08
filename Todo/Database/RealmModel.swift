//
//  RealmModel.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var regDate: Date
    @Persisted var editDate: Date
    @Persisted var detail: List<Todo>
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.regDate = Date()
        self.editDate = Date()
    }
}

class Todo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var content: String?
    @Persisted var deadLine: Date?
    @Persisted var hashTag: String?
    @Persisted var priority: String?
    @Persisted var isComplete: Bool
    @Persisted var isFlaged: Bool
    @Persisted var isFavorite: Bool
    
    @Persisted(originProperty: "detail")
    var folder: LinkingObjects<Folder>
    
    convenience init(title: String, content: String?, deadLine: Date?, hashTag: String?, priority: String?) {
        self.init()
        self.title = title
        self.content = content
        self.deadLine = deadLine
        self.hashTag = hashTag
        self.priority = priority
        self.isComplete = false
        self.isFlaged = false
        self.isFavorite = false
    }
}
