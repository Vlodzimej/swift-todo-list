//
//  TaskListRouterTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskListRouterTests
final class TaskListRouterTests: XCTestCase {
    var router: TaskListRouter!
    var mockViewController: UIViewController!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        router = TaskListRouter()
        mockViewController = UIViewController()
        mockNavigationController = MockNavigationController(rootViewController: mockViewController)
        router.view = mockViewController
    }
    
    func testOpenTaskEditPushesViewController() {
        let testTask = TaskItem(id: 1, title: "Test", todo: "ToDo test", completed: false, userId: 0, date: "10/03/25")
        
        router.openTaskEdition(with: testTask, output: nil)
        
        XCTAssertTrue(mockNavigationController.pushedViewController is TaskCreationViewController)
    }
    
    func testOpenTaskCreationPushesViewController() {
        
        router.openTaskCreation(output: nil)
        
        XCTAssertTrue(mockNavigationController.pushedViewController is TaskCreationViewController)
    }
}
