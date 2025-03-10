//
//  TaskCreationRouter.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import UIKit

// MARK: - TaskCreationRouterProtocol
protocol TaskCreationRouterProtocol {
    func dismiss()
}

// MARK: - TaskCreationRouter
final class TaskCreationRouter: TaskCreationRouterProtocol {
    
    // MARK: Properties
    weak var view: UIViewController?
    
    private var navigationController: UINavigationController? {
        view?.navigationController
    }
    
    // MARK: Public Methods
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}
