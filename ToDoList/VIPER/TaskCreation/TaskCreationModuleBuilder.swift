//
//  TaskCreationModuleBuilder.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import UIKit

// MARK: - TaskCreationModuleBuilder
final class TaskCreationModuleBuilder {
    static func build(item: TaskItem? = nil, output: TaskCreationModuleOutput? = nil) -> UIViewController {
        let router = TaskCreationRouter()
        let interactor = TaskCreationInteractor(item: item)
        let presenter = TaskCreationPresenter(router: router, interactor: interactor, output: output)
        let viewController = TaskCreationViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
