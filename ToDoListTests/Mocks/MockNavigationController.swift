//
//  MockNavigationController.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import UIKit

// MARK: - MockNavigationController
final class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    var didPopViewController = false
    var popWasAnimated = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        popWasAnimated = animated
        return super.popViewController(animated: animated)
    }
}
