//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskListRouterProtocol
protocol TaskListRouterProtocol {
    func openTaskCreation(output: TaskCreationModuleOutput?)
    func openTaskEdition(with task: TaskItem, output: TaskCreationModuleOutput?)
}

// MARK: - TaskListRouter
final class TaskListRouter: TaskListRouterProtocol {
    
    weak var view: UIViewController?
    
    private var navigationController: UINavigationController? {
        view?.navigationController
    }
    
    func openTaskCreation(output: TaskCreationModuleOutput?) {
        let viewController = TaskCreationModuleBuilder.build(output: output)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openTaskEdition(with initialTask: TaskItem, output: TaskCreationModuleOutput?) {
        let viewController = TaskCreationModuleBuilder.build(initialTask: initialTask, output: output)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
