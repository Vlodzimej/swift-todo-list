//
//  TaskItemViewCellTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskItemViewCellTests
final class TaskItemViewCellTests: XCTestCase {
    
    var cell: TaskItemViewCell!
    
    override func setUp() {
        super.setUp()
        cell = TaskItemViewCell(style: .default, reuseIdentifier: TaskItemViewCell.identifier)
        cell.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
    }
    
    func testUIElementsExist() {
        XCTAssertNotNil(cell.statusImageView, "Status image view should exist")
        XCTAssertNotNil(cell.titleLabel, "Title label should exist")
        XCTAssertNotNil(cell.descriptionLabel, "Description label should exist")
        XCTAssertNotNil(cell.dateLabel, "Date label should exist")
        XCTAssertNotNil(cell.separatorView, "Separator view should exist")
    }
    
    func testStatusImageViewConfiguration() {
        XCTAssertTrue(cell.statusImageView.isUserInteractionEnabled, "Status image should be interactive")
    }
    
    func testSeparatorConfiguration() {
        XCTAssertEqual(cell.separatorView.backgroundColor, .TaskList.Element.separator, "Separator color should match design")
    }
    
    func testCellConfiguration() {
        let task = TaskItem(id: 1, title: "Test Title", todo: "Test Description", completed: false, userId: 1, date: "01.01.2023")
        cell.configurate(model: task, isLast: false)
        
        XCTAssertEqual(cell.titleLabel.text, "Test Title", "Title should be set correctly")
        XCTAssertEqual(cell.descriptionLabel.text, "Test Description", "Description should be set correctly")
        XCTAssertEqual(cell.dateLabel.text, "01.01.2023", "Date should be set correctly")
        XCTAssertEqual(cell.statusImageView.image, UIImage(named: "empty"), "Status image should match task state")
        XCTAssertFalse(cell.separatorView.isHidden, "Separator should be visible for non-last items")
    }
    
    func testStatusImageTap() {
        class MockOutput: TaskItemViewCellOutput {
            var didCallToggle = false
            func didToggleTaskCompleteValue(taskId: Int) { didCallToggle = true }
        }
        
        let mockOutput = MockOutput()
        cell.output = mockOutput
        cell.configurate(model: TaskItem(id: 1, title: "Test", todo: "Test", completed: false, userId: 1, date: "01.01.2023"), isLast: false)
        
        cell.statusImageView.gestureRecognizers?.first?.state = .ended
        XCTAssertTrue(mockOutput.didCallToggle, "Status image tap should trigger output method")
    }
}
