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
    
    func fetchData()
    func toggleTaskCompleteValue(in taskId: Int, completion: @escaping (_ rowForUpdate: Int?) -> Void)
    func removeTask(by index: Int, completion: @escaping () -> Void)
}

// MARK: - TaskListInteractor
final class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: Properties
    private(set) var data: [TaskItem] = []
    
    // MARK: Public methods
    func fetchData() {
        data = [
            .init(id: 0, title: "Title 1", todo: "Test dsfsdfsdf \n sdfsdfdsf \n sdfsdfds \ndsfdsfsdfsd \n dsfsdfdsf", completed: false, userId: 0, date: Date.now),
            .init(id: 1, title: "Title 2", todo: "Test", completed: true, userId: 0, date: Date.now)
        ]
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
