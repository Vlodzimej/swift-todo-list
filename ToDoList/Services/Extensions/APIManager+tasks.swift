//
//  APIManager+tasks.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 06.03.2025.
//

import Foundation

// MARK: - TaskAPIManagerProtocol
protocol TaskAPIManagerProtocol {
    func getTasks(completion: @escaping (Result<TaskListInDto, Error>) -> Void)
}

extension APIManager: TaskAPIManagerProtocol {
    func getTasks(completion: @escaping (Result<TaskListInDto, Error>) -> Void) {
        request(endpoint: .fetchTasks, completion: completion)
    }
}
