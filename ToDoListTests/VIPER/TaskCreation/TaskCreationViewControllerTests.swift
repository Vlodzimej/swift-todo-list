//
//  TaskCreationViewControllerTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskCreationViewControllerTests
final class TaskCreationViewControllerTests: XCTestCase {
    var viewController: TaskCreationViewController!
    var mockPresenter: MockTaskCreationPresenter!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockTaskCreationPresenter()
        viewController = TaskCreationViewController(presenter: mockPresenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        viewController.loadViewIfNeeded()
    }
    
    func testUIElementsExist() {
        XCTAssertNotNil(viewController.titleTextField)
        XCTAssertNotNil(viewController.dateLabel)
        XCTAssertNotNil(viewController.descriptionTextView)
    }
    
    func testInitialStateForNewTask() {
        XCTAssertEqual(viewController.titleTextField.text, "")
        XCTAssertEqual(viewController.dateLabel.text, nil)
        XCTAssertEqual(viewController.descriptionTextView.text, "")
    }
    
    func testUpdateWithExistingTask() {
        let task = TaskItem(id: 1, title: "Test", todo: "Desc", completed: false, userId: 1, date: "01/01/2025")
        viewController.update(with: task)
        
        XCTAssertEqual(viewController.titleTextField.text, "Test")
        XCTAssertEqual(viewController.descriptionTextView.text, "Desc")
        XCTAssertEqual(viewController.dateLabel.text, "01/01/2025")
    }
    
    func testTitleTextFieldEditing() {
        viewController.titleTextField.text = "New Title"
        viewController.titleTextFieldDidChange()
        XCTAssertEqual(mockPresenter.updatedTitle, "New Title")
    }
}

