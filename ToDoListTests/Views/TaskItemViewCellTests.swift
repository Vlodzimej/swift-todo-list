//
//  TaskItemViewCellTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

final class TaskItemViewCellTests: XCTestCase {
    
    var cell: TaskItemViewCell!
    
    override func setUp() {
        super.setUp()
        cell = TaskItemViewCell(style: .default, reuseIdentifier: TaskItemViewCell.identifier)
        cell.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func testUIElementsExist() {
        XCTAssertNotNil(cell.statusButton, "Status button should exist")
        XCTAssertNotNil(cell.titleLabel, "Title label should exist")
        XCTAssertNotNil(cell.descriptionLabel, "Description label should exist")
        XCTAssertNotNil(cell.dateLabel, "Date label should exist")
        XCTAssertNotNil(cell.separatorView, "Separator view should exist")
    }
    
    func testSeparatorConfiguration() {
        XCTAssertEqual(cell.separatorView.backgroundColor, .TaskList.Element.separator, "Separator color should match design")
    }
    
    func testCellConfiguration() {
        let task = TaskItem(id: 1, title: "Test Title", todo: "Test Description", completed: false, userId: 1, date: "01/01/25")
        
        cell.configurate(model: task, isLast: false)
        
        XCTAssertEqual(cell.titleLabel.text, "Test Title", "Title should be set correctly")
        XCTAssertEqual(cell.descriptionLabel.text, "Test Description", "Description should be set correctly")
        XCTAssertEqual(cell.dateLabel.text, "01/01/25", "Date should be set correctly")
        XCTAssertEqual(cell.statusButton.image(for: .normal), UIImage(named: "empty"), "Status button image should match task state")
        XCTAssertFalse(cell.separatorView.isHidden, "Separator should be visible for non-last items")
    }
    
    func testCellConfigurationForCompletedTask() {
        let task = TaskItem(id: 1, title: "Test Title", todo: "Test Description", completed: true, userId: 1, date: "01/01/25")
        
        cell.configurate(model: task, isLast: true)
        
        XCTAssertEqual(cell.statusButton.image(for: .normal), UIImage(named: "ok"), "Status button image should match completed task state")
        XCTAssertTrue(cell.separatorView.isHidden, "Separator should be hidden for last items")
    }
    
    func testStatusButtonTap() {
        class MockOutput: TaskItemViewCellOutput {
            var didCallToggle = false
            var receivedTaskId: Int?
            
            func didToggleTaskCompleteValue(taskId: Int) {
                didCallToggle = true
                receivedTaskId = taskId
            }
        }
        
        let mockOutput = MockOutput()
        cell.output = mockOutput
        
        let testTask = TaskItem(id: 1, title: "Test", todo: "Test", completed: false, userId: 1, date: "01/01/25")
        
        cell.configurate(model: testTask, isLast: false)
        
        cell.statusButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockOutput.didCallToggle, "Status button tap should trigger output method")
        XCTAssertEqual(mockOutput.receivedTaskId, 1, "Should pass correct task ID")
    }
    
    func testPrepareForReuse() {
        let task = TaskItem(id: 1, title: "Test Title", todo: "Test Description", completed: true, userId: 1, date: "01/01/25")
        
        cell.configurate(model: task, isLast: false)
        cell.prepareForReuse()
        
        XCTAssertNil(cell.titleLabel.attributedText, "Title should be reset")
        XCTAssertNil(cell.descriptionLabel.attributedText, "Description should be reset")
        XCTAssertNil(cell.dateLabel.attributedText, "Date should be reset")
        XCTAssertNil(cell.taskId, "Task ID should be reset")
    }
}
