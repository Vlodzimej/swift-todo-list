//
//  TaskManager.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 07.03.2025.
//

import Foundation
import CoreData

// MARK: - TaskManagerProtocol
protocol TaskManagerProtocol: AnyObject {
    func fetchAll(completion: @escaping ([TaskItem]) -> Void)
    func addTask(_ taskItem: TaskItem, completion: @escaping (Result<TaskItem, Error>) -> Void)
    func updateTask(by taskId: Int, with taskItem: TaskItem, completion: @escaping (Result<Void, Error>) -> Void)
    func removeTask(by taskId: Int, completion: @escaping (Result<Void, Error>) -> Void)
//    func find(metaTypeId: UUID, predicates: [NSPredicate], completion: @escaping ([TaskItem]) -> Void)
//    func add(_ businessObject: TaskItem, completion: @escaping (TaskItem) -> Void)
}


// MARK: - TaskManager
final class TaskManager: TaskManagerProtocol {
    
    // MARK: Properties
    static let shared = TaskManager()
    
    private var entityName: String {
        "TaskItemCoreModel"
    }
    
    private let apiManager: APIManager
    private let coreDataManager: CoreDataManagerProtocol

    private var lastId: Int = 0
    
    // MARK: Init
    private init(apiManager: APIManager = APIManager.shared, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
    }
    
    // MARK: Private Methods
    private func setLastId(of taskList: [TaskItem]) {
        if let maxId = taskList.map({ $0.id }).max() {
            lastId = maxId
        }
    }
    
    // MARK: Public Methods
    func fetchAll(completion: @escaping ([TaskItem]) -> Void) {
        let taskListCoreData = self.coreDataManager.find(entityName: .taskItem, predicates: [])
        let taskList: [TaskItem] = taskListCoreData.compactMap({ item in
            guard let item = item as? TaskItemCoreModel else { return nil }
            return TaskItem(item)
        }).sorted(by: { $0.id > $1.id })
        
        guard taskList.isEmpty else {
            setLastId(of: taskList)
            completion(taskList)
            return
        }
        
        apiManager.getTasks { [weak self] response in
            guard let self else { return }
            switch response {
                case .success(let result):
                    let taskItems = result.convertToTaskList()
                    do {
                        try self.coreDataManager.saveEntities(entityName: .taskItem, dataArray: taskItems.compactMap { $0.toDictionary() })
                    }
                    catch {
                        debugPrint("Error")
                    }
                    
                    self.setLastId(of: taskList)
                    completion(taskItems)
                case .failure(let error):
                    debugPrint(error)
            }
        }
    }
    
    func addTask(_ taskItem: TaskItem, completion: @escaping (Result<TaskItem, Error>) -> Void) {
        var taskItem = taskItem
        lastId = lastId + 1
        taskItem.id = lastId
        
        guard let data = taskItem.toDictionary() else { return }
        coreDataManager.add(data: data, entityName: .taskItem) { result in
            switch result {
                case .success:
                    completion(.success(taskItem))
                case .failure:
                    completion(.failure(NSError(domain: "TaskManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to add task"])))
            }

        }
    }
    
    func updateTask(by taskId: Int, with taskItem: TaskItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let data = taskItem.toDictionary() else { return }
        coreDataManager.update(data: data, by: taskId, entityName: .taskItem) { result in
            switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func removeTask(by taskId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %d", taskId)
        let tasks: [TaskItemCoreModel] = coreDataManager.find(entityName: .taskItem, predicates: [predicate])
        
        if let taskToDelete = tasks.first {
            coreDataManager.remove(entity: taskToDelete) { result in
                switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        } else {
            completion(.failure(NSError(domain: "TaskManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task with id \(taskId) not found"])))
        }
    }
    
//    func find(metaTypeId: UUID, predicates: [NSPredicate], completion: @escaping ([TaskItem]) -> Void) {
//        let concurrentQueue = DispatchQueue(label: "kraeved-concurrent-queue")
//        concurrentQueue.async { [weak self] in
//            guard let self else { return }
//            var subPredicates = [NSPredicate(format: "%K = %@", "metaTypeId", metaTypeId.uuidString)]
//            subPredicates += predicates
//            let result = self.coreDataManager.find(entityName: Constants.entityName, predicates: subPredicates)
//            let businessObjects: [BusinessObject] = result.compactMap { item in
//                guard let item = item as? BusinessObjectCoreModel else { return nil }
//                return BusinessObject(item)
//            }
//            completion(businessObjects)
//        }
//    }
//    
//    func add(_ businessObject: BusinessObject, completion: @escaping (TaskItem) -> Void) {
//        let concurrentQueue = DispatchQueue(label: "kraeved-concurrent-queue")
//        concurrentQueue.async { [weak self] in
//            guard let self, let id = businessObject.id?.uuidString else { return }
//            BusinessObjectCoreModel(businessObject)
//            self.coreDataManager.saveContext()
//            let subPredicates = [NSPredicate(format: "%K = %@", "id", id)]
//            let result = self.coreDataManager.find(entityName: Constants.entityName, predicates: subPredicates)
//            guard let item = result.first, let coreDataObject = item as? BusinessObjectCoreModel else { return }
//            let businessObject = BusinessObject(coreDataObject)
//            completion(businessObject)
//        }
//    }
}
