//
//  TaskListModuleBuilder.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskListModuleBuilder
final class TaskListModuleBuilder {
    static func build() -> UIViewController {
        let router = TaskListRouter()
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(router: router, interactor: interactor)
        let viewController = TaskListViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
