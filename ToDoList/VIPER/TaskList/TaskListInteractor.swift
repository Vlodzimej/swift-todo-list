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
}
