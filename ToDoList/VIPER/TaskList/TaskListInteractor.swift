//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import Foundation

// MARK: - TaskListInteractorProtocol
protocol TaskListInteractorProtocol {
    var data: [TaskItem] { get }
    
    func fetchData(completion: @escaping () -> Void)
    func searchTasks(with searhText: String, completion: @escaping () -> Void)
    func toggleTaskCompleteValue(in taskId: Int, completion: @escaping (_ indexForUpdate: Int?) -> Void)
    func perform(taskItem: TaskItem, completion: @escaping (_ indexForUpdate: Int?, _ indexForInsert: Int?) -> Void)
    func removeTask(by index: Int, completion: @escaping (Bool) -> Void)
}

// MARK: - TaskListInteractor
final class TaskListInteractor: TaskListInteractorProtocol {

    // MARK: Properties
    private let taskManager: TaskManagerProtocol
    
    private(set) var data: [TaskItem] = []
    
    // MARK: Init
    init(taskManager: TaskManagerProtocol = TaskManager.shared) {
        self.taskManager = taskManager
    }
    
    // MARK: Public Methods
    func fetchData(completion: @escaping () -> Void) {
        taskManager.fetchAll { [weak self] taskList in
            self?.data = taskList
            completion()
        }
    }
    
    func searchTasks(with searhText: String, completion: @escaping () -> Void) {
        taskManager.getTasks(by: searhText) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let taskItems):
                    self.data = taskItems
                    completion()
                case .failure:
                    self.data = []
                    completion()
            }
        }
    }
    
    func toggleTaskCompleteValue(in taskId: Int, completion: @escaping (_ indexForUpdate: Int?) -> Void) {
        guard let index = data.firstIndex(where: { $0.id == taskId }) else { return }
        
        var taskItem = data[index]
        taskItem.completed.toggle()
        
        taskManager.updateTask(by: taskId, with: taskItem) { [weak self] result in
            switch result {
                case .success:
                    self?.data[index] = taskItem
                    completion(index)
                case .failure:
                    debugPrint("Error when switching task status")
                    completion(nil)
            }
            
        }
    }
    
    func perform(taskItem: TaskItem, completion: @escaping (_ indexForUpdate: Int?, _ indexForInsert: Int?) -> Void) {
        if let indexForUpdate = data.firstIndex(where: { $0.id == taskItem.id }) {
            data[indexForUpdate] = taskItem
            completion(indexForUpdate, nil)
        } else {
            data.insert(taskItem, at: 0)
            completion(nil, 0)
        }
    }
    
    func removeTask(by index: Int, completion: @escaping (Bool) -> Void) {
        guard let taskItem = data[safe: index] else {
            completion(false)
            return
        }
        
        taskManager.removeTask(by: taskItem.id) { [weak self] result in
            switch result {
                case .success:
                    self?.data.remove(at: index)
                    completion(true)
                case .failure:
                    completion(false)
            }
        }
    }
}
