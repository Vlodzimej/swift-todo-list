//
//  TaskItem.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import Foundation

// MARK: - TaskItem
struct TaskItem: Decodable {
    let id: Int
    let title: String?
    let todo: String
    let completed: Bool
    let userId: Int
    let date: Date?
    
    var dateString: String {
        date?.toString(dateFormat: "dd/MM/yy") ?? ""
    }
}
