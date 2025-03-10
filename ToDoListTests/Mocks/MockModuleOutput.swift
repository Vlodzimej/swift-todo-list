//
//  MockModuleOutput.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList

// MARK: - MockModuleOutput
final class MockModuleOutput: TaskCreationModuleOutput {
    var savedTask: TaskItem?
    func didFinishTaskEditing(taskItem: TaskItem?) {
        savedTask = taskItem
    }
}
