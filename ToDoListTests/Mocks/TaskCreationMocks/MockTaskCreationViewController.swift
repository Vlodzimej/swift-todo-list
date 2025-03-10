//
//  MockTaskCreationViewController.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList

// MARK: - MockTaskCreationViewController
final class MockTaskCreationViewController: TaskCreationViewProtocol {
    var didUpdateWithModel = false
    var placeholderVisible = false
    
    func update(with model: TaskItem) {
        didUpdateWithModel = true
    }
    
    func setDescriptionPlaceholder(isVisible: Bool) {
        placeholderVisible = isVisible
    }
}
