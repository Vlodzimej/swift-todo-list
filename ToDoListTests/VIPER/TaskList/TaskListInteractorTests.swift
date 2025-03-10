//
//  TaskListInteractorTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskListInteractorTests
final class TaskListInteractorTests: XCTestCase {
    var interactor: TaskListInteractor!
    var mockTaskManager: MockTaskManager!
    
    override func setUp() {
        super.setUp()
        mockTaskManager = MockTaskManager()
        interactor = TaskListInteractor(taskManager: mockTaskManager)
    }
    
    func testFetchDataSuccess() {
        let testTasks = [TaskItem(id: 1, title: "Test title 1", todo: "Test todo 1", completed: false, userId: 0, date: "10-05-2025")]
        mockTaskManager.stubFetchAll = testTasks
        
        let expectation = self.expectation(description: "Fetch data")
        interactor.fetchData {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(interactor.data.count, 1)
        XCTAssertEqual(interactor.data.first?.title, "Test title 1")
    }
    
    func testToggleTaskCompletion() {
        let testTask = TaskItem(id: 1, title: "Test title 1", todo: "Test todo 1", completed: false, userId: 0, date: "10-05-2025")
        interactor.data = [testTask]
        
        let expectation = self.expectation(description: "Toggle completion")
        interactor.toggleTaskCompleteValue(in: 1) { index in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(interactor.data.first?.completed ?? false)
        XCTAssertEqual(mockTaskManager.lastUpdatedTaskId, 1)
    }
}
