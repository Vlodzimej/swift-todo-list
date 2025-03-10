//
//  TaskItemTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class TaskItemTests: XCTestCase {
    var persistentContainer: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        persistentContainer = NSPersistentContainer(name: "ToDoListData")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        context = persistentContainer.viewContext
    }
    
    // MARK: - CoreData Conversion Tests
    func testCoreDataConversion() {
        let coreModel = TaskItemCoreModel(context: context)
        coreModel.id = 1
        coreModel.title = "Test Title"
        coreModel.todo = "Test Todo"
        coreModel.completed = true
        coreModel.userId = 123
        coreModel.date = "2025-03-04"
        
        let taskItem = TaskItem(coreModel)
        
        XCTAssertEqual(taskItem.id, Int(coreModel.id))
        XCTAssertEqual(taskItem.title, coreModel.title)
        XCTAssertEqual(taskItem.todo, coreModel.todo ?? "")
        XCTAssertEqual(taskItem.completed, coreModel.completed)
        XCTAssertEqual(taskItem.userId, Int(coreModel.userId))
        XCTAssertEqual(taskItem.date, coreModel.date)
    }
    
    func testReverseCoreDataConversion() {
        let taskItem = TaskItem(
            id: 2,
            title: "Reverse Test",
            todo: "Reverse Conversion",
            completed: false,
            userId: 456,
            date: "2025-03-05"
        )
        
        let coreModel = TaskItemCoreModel(context: context)
        coreModel.id = Int32(taskItem.id)
        coreModel.title = taskItem.title
        coreModel.todo = taskItem.todo
        coreModel.completed = taskItem.completed
        coreModel.userId = Int32(taskItem.userId)
        coreModel.date = taskItem.date
        
        XCTAssertEqual(coreModel.id, Int32(taskItem.id))
        XCTAssertEqual(coreModel.title, taskItem.title)
        XCTAssertEqual(coreModel.todo, taskItem.todo)
        XCTAssertEqual(coreModel.completed, taskItem.completed)
        XCTAssertEqual(coreModel.userId, Int32(taskItem.userId))
        XCTAssertEqual(coreModel.date, taskItem.date)
    }
    
    // MARK: - Custom Operator Tests
    func testCustomInequalityOperator() {
        let item1 = TaskItem(
            id: 1,
            title: "Title A",
            todo: "Todo A",
            completed: false,
            userId: 123,
            date: "2025-01-01"
        )
        
        let item2 = TaskItem(
            id: 2,
            title: "Title B",
            todo: "Todo B",
            completed: true,
            userId: 456,
            date: "2025-02-02"
        )
        
        let item3 = TaskItem(
            id: 3,
            title: "Title A",
            todo: "Todo A",
            completed: true,
            userId: 789,
            date: "2025-03-03"
        )
        
        XCTAssertTrue(item1 != item2, "Should be different in title or todo")
        XCTAssertFalse(item1 != item3, "Should be equal in title and todo")
    }
    
    // MARK: - Codable Tests
    func testCodableWithCoreDataFields() throws {
        let originalItem = TaskItem(
            id: 1,
            title: "Codable Title",
            todo: "Codable Todo",
            completed: true,
            userId: 123,
            date: "2025-03-04"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalItem)
        
        let decoder = JSONDecoder()
        let decodedItem = try decoder.decode(TaskItem.self, from: data)
        
        XCTAssertEqual(originalItem, decodedItem)
    }
    
    // MARK: - Edge Cases
    func testNilValuesConversion() {
        let coreModel = TaskItemCoreModel(context: context)
        coreModel.id = 1
        coreModel.title = nil
        coreModel.todo = "Nil Test"
        coreModel.completed = false
        coreModel.userId = 123
        coreModel.date = nil
        
        let taskItem = TaskItem(coreModel)
        
        XCTAssertNil(taskItem.title)
        XCTAssertNil(taskItem.date)
        XCTAssertEqual(taskItem.todo, "Nil Test")
    }
    
    func testMaxValueConversion() {
        let maxId = Int(Int32.max)
        let coreModel = TaskItemCoreModel(context: context)
        coreModel.id = Int32.max
        coreModel.userId = Int32.max
        
        let taskItem = TaskItem(coreModel)
        
        XCTAssertEqual(taskItem.id, maxId)
        XCTAssertEqual(taskItem.userId, maxId)
    }
    
    // MARK: - Equatable Tests
    func testFullEqualityCheck() {
        let item1 = TaskItem(
            id: 1,
            title: "Test",
            todo: "Test",
            completed: false,
            userId: 123,
            date: "2025-01-01"
        )
        
        let item2 = TaskItem(
            id: 1,
            title: "Test",
            todo: "Test",
            completed: false,
            userId: 123,
            date: "2025-01-01"
        )
        
        let item3 = TaskItem(
            id: 1,
            title: "Test",
            todo: "Test",
            completed: true,
            userId: 123,
            date: "2025-01-01"
        )
        
        XCTAssertEqual(item1, item2)
        XCTAssertNotEqual(item1, item3)
    }
}
