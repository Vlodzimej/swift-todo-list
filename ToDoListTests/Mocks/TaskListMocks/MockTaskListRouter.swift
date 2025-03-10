//
//  MockTaskListRouter.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList

// MARK: - MockTaskListRouter
class MockTaskListRouter: TaskListRouterProtocol {
    var didOpenEdit = false
    var lastEditedTask: TaskItem?
    
    func openTaskCreation(output: TaskCreationModuleOutput?) {}
    
    func openTaskEdition(with task: TaskItem, output: TaskCreationModuleOutput?) {
        didOpenEdit = true
        lastEditedTask = task
    }
}
