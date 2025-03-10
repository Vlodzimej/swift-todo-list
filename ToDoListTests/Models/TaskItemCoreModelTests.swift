//
//  TaskItemCoreModelTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
import CoreData
@testable import ToDoList

// MARK: - TaskItemCoreModelTests
final class TaskItemCoreModelTests: XCTestCase {
    var persistentContainer: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let modelURL = Bundle.main.url(forResource: "ToDoListData", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        persistentContainer = NSPersistentContainer(
            name: "ToDoListData",
            managedObjectModel: model
        )
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Setup CoreData stack")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        context = persistentContainer.viewContext
    }
    
    // MARK: - Test Entity Existence
    func testEntityExistence() {
        let entity = NSEntityDescription.entity(
            forEntityName: "TaskItemCoreModel",
            in: context
        )
        XCTAssertNotNil(entity, "Entity 'TaskItemCoreModel' not found in model")
    }
    
    // MARK: - Test CoreData Persistence
    func testCoreDataPersistence() throws {
        let taskItem = TaskItem(
            id: 1,
            title: "Persisted",
            todo: "Persist test",
            completed: true,
            userId: 123,
            date: "2025-03-04"
        )

        let coreModel = TaskItemCoreModel(context: context)
        coreModel.id = Int32(taskItem.id)
        coreModel.title = taskItem.title
        coreModel.todo = taskItem.todo
        coreModel.completed = taskItem.completed
        coreModel.userId = Int32(taskItem.userId)
        coreModel.date = taskItem.date
        
        try context.save()

        let fetchRequest = TaskItemCoreModel.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Persisted")
    }
    
    // MARK: - Convenience Initializer Test
    func testConvenienceInitializer() {
        let taskItem = TaskItem(
            id: 2,
            title: "Test",
            todo: "Test Todo",
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
        
        XCTAssertEqual(coreModel.id, 2)
        XCTAssertEqual(coreModel.todo, "Test Todo")
    }
}
