//
//  TaskCreationModuleBuilder.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import UIKit

// MARK: - TaskCreationModuleBuilder
final class TaskCreationModuleBuilder {
    static func build(initialTask: TaskItem? = nil, output: TaskCreationModuleOutput? = nil) -> UIViewController {
        let interactor = TaskCreationInteractor(initialTask: initialTask)
        let presenter = TaskCreationPresenter(interactor: interactor, output: output)
        let viewController = TaskCreationViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
