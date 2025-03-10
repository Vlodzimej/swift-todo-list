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
    var currentTask: TaskItem { get }
    var maxTitleLength: Int { get }
    var maxDescriptionLength: Int { get }
    
    func update(title: String)
    func update(todo: String)
    func performCurrentTask(completion: @escaping (_ taskItem: TaskItem?) -> Void)
}

// MARK: - TaskCreationInteractor
final class TaskCreationInteractor: TaskCreationInteractorProtocol {
    
    // MARK: Properties
    let taskManager: TaskManagerProtocol
    
    let initialTask: TaskItem?
    private(set) var currentTask: TaskItem
    
    var maxTitleLength: Int {
        50
    }
    
    var maxDescriptionLength: Int {
        1000
    }
    
    // MARK: Init
    init(taskManager: TaskManagerProtocol = TaskManager.shared, initialTask: TaskItem? = nil) {
        self.taskManager = taskManager
        self.initialTask = initialTask
        self.currentTask = initialTask ?? TaskItem(id: 0, title: "", todo: "", completed: false, userId: 0, date: Date.now.toString(dateFormat: "dd/MM/yy"))
    }
    
    // MARK: Public Methods
    func update(title: String) {
        currentTask.title = title
    }
    
    func update(todo: String) {
        currentTask.todo = todo
    }
    
    func performCurrentTask(completion: @escaping (_ taskItem: TaskItem?) -> Void) {
        if initialTask == nil {
            if !(currentTask.title ?? "").isEmpty && !currentTask.todo.isEmpty {
                taskManager.addTask(currentTask) { result in
                    switch result {
                        case .success(let storedTaskItem):
                            completion(storedTaskItem)
                        case .failure:
                            completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        } else if initialTask != currentTask {
            taskManager.updateTask(by: currentTask.id, with: currentTask) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success:
                        completion(self.currentTask)
                    case .failure:
                        completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
