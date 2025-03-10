//
//  TaskCreationInteractorTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskCreationInteractorTests
final class TaskCreationInteractorTests: XCTestCase {
    var interactor: TaskCreationInteractor!
    var mockTaskManager: MockTaskManager!
    
    override func setUp() {
        super.setUp()
        mockTaskManager = MockTaskManager()
    }
    
    func testInitializationWithNewTask() {
        interactor = TaskCreationInteractor(taskManager: mockTaskManager)
        XCTAssertNil(interactor.initialTask)
        XCTAssertEqual(interactor.currentTask.title, "")
    }
    
    func testInitializationWithExistingTask() {
        let task = TaskItem(id: 1, title: "Test", todo: "Desc", completed: false, userId: 1, date: "01.01.2023")
        interactor = TaskCreationInteractor(taskManager: mockTaskManager, initialTask: task)
        XCTAssertEqual(interactor.initialTask?.id, 1)
        XCTAssertEqual(interactor.currentTask.title, "Test")
    }
    
    func testUpdateTitle() {
        interactor = TaskCreationInteractor()
        interactor.update(title: "New Title")
        XCTAssertEqual(interactor.currentTask.title, "New Title")
    }
    
    func testUpdateTodo() {
        interactor = TaskCreationInteractor()
        interactor.update(todo: "New Description")
        XCTAssertEqual(interactor.currentTask.todo, "New Description")
    }
    
    func testAddNewTaskSuccess() {
        mockTaskManager.stubAddTask = .success(TaskItem(id: 1, title: "Test", todo: "Desc", completed: false, userId: 1, date: "01.01.2023"))
        interactor = TaskCreationInteractor(taskManager: mockTaskManager)
        interactor.update(title: "Test")
        interactor.update(todo: "Desc")
        
        let expectation = self.expectation(description: "Add task")
        interactor.performCurrentTask { task in
            XCTAssertNotNil(task)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateExistingTaskFailure() {
        let initialTask = TaskItem(id: 1, title: "Old", todo: "Old Desc", completed: false, userId: 1, date: "01/01/25")
        mockTaskManager.stubUpdateTask = .failure(NSError(domain: "test", code: 1))
        interactor = TaskCreationInteractor(taskManager: mockTaskManager, initialTask: initialTask)
        interactor.update(title: "New Title")
        interactor.update(todo: "New Desc")
        
        let expectation = self.expectation(description: "Update task")
        interactor.performCurrentTask { task in
            let comparableTask = TaskItem(id: 1, title: "New Title", todo: "New Desc", completed: false, userId: 1, date: "01/01/25")
            XCTAssertEqual(task, comparableTask)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
