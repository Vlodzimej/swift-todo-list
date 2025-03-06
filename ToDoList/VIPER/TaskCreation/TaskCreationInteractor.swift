//
//  TaskCreationInteractor.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import Foundation

// MARK: - TaskCreationInteractorProtocol
protocol TaskCreationInteractorProtocol {
    var initialTask: TaskItem? { get }
    var task: TaskItem { get }
    var maxTitleLength: Int { get }
    var maxDescriptionLength: Int { get }
    
    func update(title: String)
    func update(todo: String)
}

// MARK: - TaskCreationInteractor
final class TaskCreationInteractor: TaskCreationInteractorProtocol {
    
    // MARK: Properties
    let initialTask: TaskItem?
    private(set) var task: TaskItem
    
    var maxTitleLength: Int {
        50
    }
    
    var maxDescriptionLength: Int {
        1000
    }
    
    // MARK: Init
    init(initialTask: TaskItem? = nil) {
        self.initialTask = initialTask
        self.task = initialTask ?? TaskItem(id: 0, todo: "", completed: false, userId: 0, date: Date.now)
    }
    
    func update(title: String) {
        task.title = title
    }
    
    func update(todo: String) {
        task.todo = todo
    }
    
}
