//
//  TaskManagerMock.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList

// MARK: - Mock TaskManager
final class MockTaskManager: TaskManagerProtocol {
    
    var stubFetchAll: [TaskItem] = [
        TaskItem(id: 0, title: "Test title 1", todo: "Test todo 1", completed: false, userId: 0, date: "10-05-2025")
    ]
    var lastUpdatedTaskId: Int?
    
    var stubAddTask: Result<TaskItem, Error> = .success(TaskItem(id: 0, title: "Test", todo: "Test", completed: false, userId: 0, date: "10/03/25"))
    var stubUpdateTask: Result<Void, Error> = .success(())
    
    func fetchAll(completion: @escaping ([TaskItem]) -> Void) {
        completion(stubFetchAll)
    }
    
    func updateTask(by id: Int, with task: TaskItem, completion: @escaping (Result<Void, Error>) -> Void) {
        lastUpdatedTaskId = id
        completion(.success(()))
    }
    
    func addTask(_ taskItem: ToDoList.TaskItem, completion: @escaping (Result<ToDoList.TaskItem, any Error>) -> Void) {
        let taskItem = TaskItem(id: 1, title: "Test title 2", todo: "Test todo 2", completed: false, userId: 0, date: "10-05-2025")
        completion(.success(taskItem))
    }
    
    func removeTask(by taskId: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        completion(.success(()))
    }
    
    func getTasks(by searchText: String, completion: @escaping (Result<[ToDoList.TaskItem], any Error>) -> Void) {
        if let taskItem = stubFetchAll.first(where: { ($0.title ?? "").contains(searchText)}) {
            completion(.success([taskItem]))
        } else {
            completion(.success([]))
        }
    }
}

