//
//  TaskListFooterViewTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskListFooterViewTests
final class TaskListFooterViewTests: XCTestCase {
    
    var footerView: TaskListFooterView!
    
    override func setUp() {
        super.setUp()
        footerView = TaskListFooterView()
        footerView.frame = CGRect(x: 0, y: 0, width: 320, height: 60)
    }
    
    func testElementsExist() {
        XCTAssertNotNil(footerView.separatorView, "Separator view should exist")
        XCTAssertNotNil(footerView.countLabel, "Count label should exist")
        XCTAssertNotNil(footerView.addButton, "Add button should exist")
    }
    
    func testCountLabelConfiguration() {
        XCTAssertEqual(footerView.countLabel.font, .systemFont(ofSize: 13), "Count label font should be 13pt")
        XCTAssertEqual(footerView.countLabel.textColor, .TaskList.Foreground.primary, "Count label text color should match design")
    }
    
    func testAddButtonConfiguration() {
        XCTAssertNotNil(footerView.addButton.image(for: .normal), "Add button should have an image")
        XCTAssertTrue(footerView.addButton.allTargets.contains(footerView!), "Add button should have target")
    }
    
    func testUpdateCount() {
        footerView.updateCount(with: 5)
        XCTAssertEqual(footerView.countLabel.text, "5 tasks", "Count label should display correct text")
    }
    
    func testAddButtonAction() {
        class MockOutput: TaskListFooterOutput {
            var didCallOpenTaskCreation = false
            func openTaskCreation() { didCallOpenTaskCreation = true }
        }
        
        let mockOutput = MockOutput()
        footerView.output = mockOutput
        
        footerView.addButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(mockOutput.didCallOpenTaskCreation, "Add button tap should trigger output method")
    }
}
