//
//  TaskItemDtoIn.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

final class TaskListInDtoTests: XCTestCase {
    
    // MARK: - Decoding Tests
    func testDecodingValidJSON() throws {
        let json = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Buy groceries",
                    "completed": false,
                    "userId": 42
                },
                {
                    "id": 2,
                    "todo": "Do homework",
                    "completed": true,
                    "userId": 24
                }
            ]
        }
        """.data(using: .utf8)!
        
        let dto = try JSONDecoder().decode(TaskListInDto.self, from: json)
        
        XCTAssertEqual(dto.todos.count, 2)
        XCTAssertEqual(dto.todos[0].id, 1)
        XCTAssertEqual(dto.todos[0].todo, "Buy groceries")
        XCTAssertEqual(dto.todos[0].completed, false)
        XCTAssertEqual(dto.todos[0].userId, 42)
    }
    
    func testDecodingMissingField() {
        // Arrange
        let json = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Test",
                    "userId": 42
                }
            ]
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(TaskListInDto.self, from: json)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    // MARK: - Conversion Tests
    func testConversionToTaskList() {
        let dto = TaskListInDto(todos: [
            TaskListInDto.TaskInDto(
                id: 1,
                todo: "Very long task description that exceeds 32 characters limit",
                completed: true,
                userId: 100
            ),
            TaskListInDto.TaskInDto(
                id: 2,
                todo: "Short task",
                completed: false,
                userId: 200
            )
        ])
        
        let taskList = dto.convertToTaskList()
        
        XCTAssertEqual(taskList.count, 2)
        
        XCTAssertEqual(taskList[0].title, "Very long task description that ")
        XCTAssertEqual(taskList[0].todo, "Very long task description that exceeds 32 characters limit")
        XCTAssertEqual(taskList[0].completed, true)
        XCTAssertEqual(taskList[0].userId, 100)
        
        XCTAssertEqual(taskList[1].title, "Short task")
        XCTAssertEqual(taskList[1].todo, "Short task")
        XCTAssertEqual(taskList[1].completed, false)
        XCTAssertEqual(taskList[1].userId, 200)
    }
    
    // MARK: - Edge Cases
    func testEmptyTodoConversion() {
        let dto = TaskListInDto(todos: [
            TaskListInDto.TaskInDto(
                id: 1,
                todo: "",
                completed: false,
                userId: 0
            )
        ])
        
        let taskList = dto.convertToTaskList()
        
        XCTAssertEqual(taskList[0].title, "")
        XCTAssertEqual(taskList[0].todo, "")
    }
    
    func testExact32CharacterTitle() {
        let exact32 = String(repeating: "a", count: 32)
        let dto = TaskListInDto(todos: [
            TaskListInDto.TaskInDto(
                id: 1,
                todo: exact32,
                completed: false,
                userId: 0
            )
        ])

        let taskList = dto.convertToTaskList()
        
        XCTAssertEqual(taskList[0].title, exact32)
    }
}
