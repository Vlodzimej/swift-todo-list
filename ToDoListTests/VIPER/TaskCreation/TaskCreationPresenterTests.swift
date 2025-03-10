//
//  TaskCreationPresenterTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskCreationPresenterTests
final class TaskCreationPresenterTests: XCTestCase {
    var presenter: TaskCreationPresenter!
    var mockInteractor: MockTaskCreationInteractor!
    var mockView: MockTaskCreationViewController!
    var mockOutput: MockModuleOutput!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockTaskCreationInteractor()
        mockView = MockTaskCreationViewController()
        mockOutput = MockModuleOutput()
        
        presenter = TaskCreationPresenter(
            interactor: mockInteractor,
            output: mockOutput
        )
        presenter.view = mockView
    }
    
    func testViewDidLoadWithExistingTask() {
        let task = TaskItem(id: 1, title: "Test", todo: "Desc", completed: false, userId: 1, date: "01.01.2023")
        mockInteractor.initialTask = task
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockView.didUpdateWithModel)
        XCTAssertFalse(mockView.placeholderVisible)
    }
    
    func testViewDidLoadWithNewTask() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockView.placeholderVisible)
    }
    
    func testTitleDidChange() {
        presenter.titleDidChange(newValue: "New Title")
        XCTAssertEqual(mockInteractor.updatedTitle, "New Title")
    }
    
    func testTextViewDidChange() {
        let textView = UITextView()
        textView.text = "New Description"
        presenter.textViewDidChange(textView)
        XCTAssertEqual(mockInteractor.updatedTodo, "New Description")
    }
    
    func testTitleMaxLengthValidation() {
        let textField = UITextField()
        textField.text = String(repeating: "a", count: 100)
        
        let result = presenter.textField(
            textField,
            shouldChangeCharactersIn: NSRange(),
            replacementString: "b"
        )
        
        XCTAssertFalse(result)
    }
    
    func testDescriptionMaxLengthValidation() {
        let textView = UITextView()
        textView.text = String(repeating: "a", count: 2000)
        
        let result = presenter.textView(
            textView,
            shouldChangeTextIn: NSRange(),
            replacementText: "b"
        )
        
        XCTAssertFalse(result)
    }
    
    func testPerformTaskSuccess() {
        mockInteractor.stubPerformTask = TaskItem(id: 1, title: "Test", todo: "Desc", completed: false, userId: 1, date: "01.01.2023")
        
        let expectation = self.expectation(description: "Save task")
        presenter.performCurrentTask {
            XCTAssertEqual(self.mockOutput.savedTask?.title, "Test")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}


