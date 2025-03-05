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
    func openTaskEdition(with item: TaskItem, output: TaskCreationModuleOutput?)
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
    
    func openTaskEdition(with item: TaskItem, output: TaskCreationModuleOutput?) {
        let viewController = TaskCreationModuleBuilder.build(item: item, output: output)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
