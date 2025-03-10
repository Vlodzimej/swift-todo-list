//
//  TaskCreationRouterTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskCreationRouterTests
final class TaskCreationRouterTests: XCTestCase {
    
    var router: TaskCreationRouter!
    var mockNavigationController: MockNavigationController!
    var mockViewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        router = TaskCreationRouter()
        mockViewController = UIViewController()
        let firstVC = UIViewController()
        mockNavigationController = MockNavigationController(rootViewController: firstVC)
        router.view = mockViewController
        
        mockNavigationController.viewControllers = [mockViewController]
        
        router = TaskCreationRouter()
        router.view = mockViewController
    }
    
    override func tearDown() {
        router = nil
        mockNavigationController = nil
        mockViewController = nil
        super.tearDown()
    }
    
    func testDismiss() {
        router.dismiss()
        
        XCTAssertTrue(mockNavigationController.didPopViewController, "Router should pop view controller")
        XCTAssertTrue(mockNavigationController.popWasAnimated, "Pop should be animated")
    }
    
    func testDismissWithoutNavigationController() {
        let viewController = UIViewController()
        router.view = viewController
        router.dismiss()
        
        XCTAssertFalse(mockNavigationController.didPopViewController, "Should not pop if no navigation controller")
    }
}
