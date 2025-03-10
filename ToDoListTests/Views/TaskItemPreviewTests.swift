//
//  TaskItemPreviewTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskItemPreviewViewControllerTests
final class TaskItemPreviewViewControllerTests: XCTestCase {
    
    var previewVC: TaskItemPreviewViewController!
    
    override func setUp() {
        super.setUp()
        let task = TaskItem(id: 1, title: "Test Title", todo: "Test Description", completed: false, userId: 1, date: "01/01/2025")
        previewVC = TaskItemPreviewViewController(model: task)
        _ = previewVC.view // Trigger viewDidLoad
    }
    
    func testUIElementsExist() {
        XCTAssertNotNil(previewVC.view.subviews.first as? UIStackView, "Stack view should exist")
        guard let stackView = previewVC.view.subviews.first as? UIStackView else { return }
        
        XCTAssertEqual(stackView.arrangedSubviews.count, 3, "Stack view should contain 3 labels")
        XCTAssertTrue(stackView.arrangedSubviews[0] is UILabel, "First subview should be title label")
        XCTAssertTrue(stackView.arrangedSubviews[1] is UILabel, "Second subview should be description label")
        XCTAssertTrue(stackView.arrangedSubviews[2] is UILabel, "Third subview should be date label")
    }
    
    func testViewConfiguration() {
        XCTAssertEqual(previewVC.view.backgroundColor, .TaskList.Background.second, "Background color should match design")
        XCTAssertEqual(previewVC.view.layer.cornerRadius, 12, "Corner radius should match design")
    }
    
    func testContentConfiguration() {
        guard let stackView = previewVC.view.subviews.first as? UIStackView,
              let titleLabel = stackView.arrangedSubviews[0] as? UILabel,
              let descriptionLabel = stackView.arrangedSubviews[1] as? UILabel,
              let dateLabel = stackView.arrangedSubviews[2] as? UILabel else {
            XCTFail("UI elements not found")
            return
        }
        
        XCTAssertEqual(titleLabel.text, "Test Title", "Title should be set correctly")
        XCTAssertEqual(descriptionLabel.text, "Test Description", "Description should be set correctly")
        XCTAssertEqual(dateLabel.text, "01/01/25", "Date should be set correctly")
    }
}
