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
    func toggleTaskCompleteValue(in taskId: Int, completion: @escaping (_ rowForUpdate: Int?) -> Void)
    func removeTask(by index: Int, completion: @escaping () -> Void)
}

// MARK: - TaskListInteractor
final class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: Properties
    private let apiManager: TaskAPIManagerProtocol
    
    private(set) var data: [TaskItem] = []
    
    // MARK: Init
    init(apiManager: TaskAPIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    // MARK: Public methods
    func fetchData(completion: @escaping () -> Void) {
        apiManager.getTasks { [weak self] response in
            guard let self else { return }
            
            switch response {
                case .success(let result):
                    self.data = result.convertToTaskList()
                case .failure:
                    #warning("TODO: Отображать ошибку")
            }
            
            completion()
        }
    }
    
    func toggleTaskCompleteValue(in taskId: Int, completion: @escaping (_ rowForUpdate: Int?) -> Void) {
        guard let index = data.firstIndex(where: { $0.id == taskId }) else { return }
        data[index].completed.toggle()
        #warning("TODO: Обновление записи")

        completion(index)
    }
    
    func removeTask(by index: Int, completion: @escaping () -> Void) {
        #warning("TODO: Удаление записи")
        data.remove(at: index)
        completion()
    }
}
