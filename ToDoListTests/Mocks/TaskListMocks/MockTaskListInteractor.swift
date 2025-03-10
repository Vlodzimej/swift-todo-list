//
//  MockTaskListInteractor.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList

// MARK: - MockTaskListInteractor
class MockTaskListInteractor: TaskListInteractorProtocol {
    
    var data: [TaskItem] = []
    var didFetchData = false
    var didSearch = false
    var lastSearchQuery: String?
    var stubData:  [TaskItem] = [
        TaskItem(id: 0, title: "Test title 1", todo: "Test todo 1", completed: false, userId: 0, date: "10-05-2025"),
        TaskItem(id: 1, title: "Test title 2", todo: "Test todo 2", completed: true, userId: 0, date: "10-05-2025")
    ]
    var fetchDataStub: (() -> Void)?
    
    func fetchData(completion: @escaping () -> Void) {
        didFetchData = true
        fetchDataStub?()
        completion()
    }
    
    func searchTasks(with searchText: String, completion: @escaping () -> Void) {
        lastSearchQuery = searchText
        didSearch = true
        completion()
    }
    
    func toggleTaskCompleteValue(in taskId: Int, completion: @escaping (Int?) -> Void) {
        if let index = stubData.firstIndex(where: { $0.id == taskId }) {
            stubData[index].completed.toggle()
            completion(index)
        } else {
            completion(nil)
        }
    }
    
    func perform(taskItem: ToDoList.TaskItem, completion: @escaping (Int?, Int?) -> Void) {
        if let index = stubData.firstIndex(where: { $0.id == taskItem.id }) {
            stubData[index] = taskItem
            completion(index, nil)
        } else {
            stubData.insert(taskItem, at: 0)
            completion(nil, 0)
        }
    }
    
    func removeTask(by index: Int, completion: @escaping (Bool) -> Void) {
        if stubData[safe: index] != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
}
