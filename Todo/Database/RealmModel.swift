//
//  RealmModel.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var deadLine: Date?
    @Persisted var hashTag: String?
    @Persisted var priority: String?
    
    convenience init(title: String, content: String?, deadLine: Date?, hashTag: String?, priority: String?) {
        self.init()
        self.title = title
        self.content = content
        self.deadLine = deadLine
        self.hashTag = hashTag
        self.priority = priority
    }
}
