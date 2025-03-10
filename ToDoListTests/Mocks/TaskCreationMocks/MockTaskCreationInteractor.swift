//
//  MockTaskCreationInteractor.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList

// MARK: - MockTaskCreationInteractor
final class MockTaskCreationInteractor: TaskCreationInteractorProtocol {
    var initialTask: TaskItem?
    var currentTask = TaskItem(id: 0, title: "", todo: "", completed: false, userId: 0, date: "")
    var maxTitleLength: Int = 50
    var maxDescriptionLength: Int = 1000
    var updatedTitle: String?
    var updatedTodo: String?
    var stubPerformTask: TaskItem?
    
    func update(title: String) { updatedTitle = title }
    func update(todo: String) { updatedTodo = todo }
    func performCurrentTask(completion: @escaping (TaskItem?) -> Void) {
        completion(stubPerformTask)
    }
}
