//
//  TaskListInDto.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 06.03.2025.
//

import Foundation

// MARK: - TaskListInDto
struct TaskListInDto: Decodable {
    
    // MARK - TaskInDto
    struct TaskInDto: Decodable {
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
    
    let todos: [TaskInDto]
    
    func convertToTaskList() -> [TaskItem] {
        todos.map { TaskItem(id: $0.id,
                             title: String($0.todo.prefix(32)),
                             todo: $0.todo,
                             completed: $0.completed,
                             userId: $0.userId,
                             date: Date.now) }
    }
}
