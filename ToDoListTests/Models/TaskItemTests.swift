//
//  TaskItemTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

final class TaskItemTests: XCTestCase {
    
    // MARK: - Test Initialization
    
    func testTaskItemInitialization() {
        // Given
        let id = 1
        let title = "Test Title"
        let todo = "Test Todo"
        let completed = false
        let userId = 123
        let date = "2025-03-04"
        
        // When
        let taskItem = TaskItem(
            id: id,
            title: title,
            todo: todo,
            completed: completed,
            userId: userId,
            date: date
        )
        
        // Then
        XCTAssertEqual(taskItem.id, id)
        XCTAssertEqual(taskItem.title, title)
        XCTAssertEqual(taskItem.todo, todo)
        XCTAssertEqual(taskItem.completed, completed)
        XCTAssertEqual(taskItem.userId, userId)
        XCTAssertEqual(taskItem.date, date)
    }
    
    // MARK: - Test Core Model Conversion
    
    func testCoreModelConversion() {
        // Given
        let coreModel = TaskItemCoreModel(
            id: 1,
            title: "Core Title",
            todo: "Core Todo",
            completed: true,
            userId: 456,
            date: "2025-03-05"
        )
        
        // When
        let taskItem = TaskItem(coreModel)
        
        // Then
        XCTAssertEqual(taskItem.id, Int(coreModel.id))
        XCTAssertEqual(taskItem.title, coreModel.title)
        XCTAssertEqual(taskItem.todo, coreModel.todo ?? "")
        XCTAssertEqual(taskItem.completed, coreModel.completed)
        XCTAssertEqual(taskItem.userId, Int(coreModel.userId))
        XCTAssertEqual(taskItem.date, coreModel.date)
    }
    
    // MARK: - Test Custom Inequality Operator
    
    func testCustomInequality() {
        // Given
        let item1 = TaskItem(
            id: 1,
            title: "Title 1",
            todo: "Todo 1",
            completed: false,
            userId: 123,
            date: "2025-01-01"
        )
        
        let item2 = TaskItem(
            id: 2,
            title: "Title 2",
            todo: "Todo 2",
            completed: true,
            userId: 456,
            date: "2025-02-02"
        )
        
        let item3 = TaskItem(
            id: 3,
            title: "Title 1",
            todo: "Todo 1",
            completed: true,
            userId: 789,
            date: "2025-03-03"
        )
        
        // Then
        XCTAssertTrue(item1 != item2, "Should be different")
        XCTAssertFalse(item1 != item3, "Should be equal")
    }
    
    // MARK: - Test Codable Conformance
    
    func testCodableConformance() throws {
        // Given
        let originalItem = TaskItem(
            id: 1,
            title: "Codable Title",
            todo: "Codable Todo",
            completed: true,
            userId: 123,
            date: "2025-03-04"
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalItem)
        
        let decoder = JSONDecoder()
        let decodedItem = try decoder.decode(TaskItem.self, from: data)
        
        // Then
        XCTAssertEqual(originalItem, decodedItem)
    }
    
    // MARK: - Test Equatable Conformance
    
    func testEquatableConformance() {
        // Given
        let item1 = TaskItem(
            id: 1,
            title: "Test",
            todo: "Test",
            completed: false,
            userId: 123,
            date: nil
        )
        
        let item2 = TaskItem(
            id: 1,
            title: "Test",
            todo: "Test",
            completed: false,
            userId: 123,
            date: nil
        )
        
        let item3 = TaskItem(
            id: 2,
            title: "Different",
            todo: "Different",
            completed: true,
            userId: 456,
            date: "2025-03-04"
        )
        
        // Then
        XCTAssertEqual(item1, item2)
        XCTAssertNotEqual(item1, item3)
    }
    
    // MARK: - Edge Cases
    
    func testNilTitleHandling() {
        // Given
        let taskItem = TaskItem(
            id: 1,
            title: nil,
            todo: "Todo",
            completed: false,
            userId: 123,
            date: "2025-03-04"
        )
        
        // Then
        XCTAssertNil(taskItem.title)
        XCTAssertEqual(taskItem.todo, "Todo")
    }
    
    func testEmptyDateHandling() {
        // Given
        let taskItem = TaskItem(
            id: 1,
            title: "Title",
            todo: "Todo",
            completed: false,
            userId: 123,
            date: nil
        )
        
        // Then
        XCTAssertNil(taskItem.date)
    }
}
