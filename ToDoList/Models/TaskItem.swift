//
//  TaskItem.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import Foundation

// MARK: - TaskItem
struct TaskItem: Codable, Equatable {
    var id: Int
    var title: String?
    var todo: String
    var completed: Bool
    let userId: Int
    let date: String?
    
    init(id: Int, title: String?, todo: String, completed: Bool, userId: Int, date: String?) {
        self.id = id
        self.title = title
        self.todo = todo
        self.completed = completed
        self.userId = userId
        self.date = date
    }
    
    init(_ taskItem: TaskItemCoreModel) {
        self.id = Int(taskItem.id)
        self.title = taskItem.title
        self.todo = taskItem.todo ?? ""
        self.completed = taskItem.completed
        self.userId = Int(taskItem.userId)
        self.date = taskItem.date
    }
    
    static func != (lhs: TaskItem, rhs: TaskItem) -> Bool {
        lhs.title != rhs.title || lhs.todo != rhs.todo
    }
    
}
