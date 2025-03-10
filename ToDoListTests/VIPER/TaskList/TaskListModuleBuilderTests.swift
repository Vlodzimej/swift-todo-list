//
//  TaskListModuleBuilderTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskListModuleBuilderTests
final class TaskListModuleBuilderTests: XCTestCase {
    
    func testModuleAssembly() {
        let viewController = TaskListModuleBuilder.build() as! TaskListViewController
        
        XCTAssertNotNil(viewController, "ViewController not created")
        XCTAssertTrue(viewController is TaskListViewController, "Invalid ViewController type")
        
        let presenter = viewController.presenter
        XCTAssertNotNil(presenter, "Presenter not created")
        XCTAssertTrue(presenter is TaskListPresenter, "Invalid Presenter type")
        
        guard let taskListPresenter = presenter as? TaskListPresenter else {
            XCTFail("Presenter does not conform to protocol")
            return
        }
        
        XCTAssertNotNil(taskListPresenter.router, "Router not created")
        XCTAssertTrue(taskListPresenter.router is TaskListRouter, "Invalid Router type")
        
        XCTAssertNotNil(taskListPresenter.interactor, "Interactor not created")
        XCTAssertTrue(taskListPresenter.interactor is TaskListInteractor, "Invalid Interactor type")
        
        guard let router = taskListPresenter.router as? TaskListRouter else {
            XCTFail("Router does not conform to protocol")
            return
        }
        XCTAssertTrue(router.view === viewController, "Router has no reference to ViewController")
        
        XCTAssertTrue(viewController.presenter === presenter, "Presenter is not attached to View")
        
        guard let interactor = taskListPresenter.interactor as? TaskListInteractor else {
            XCTFail("Interactor does not conform to protocol")
            return
        }
        XCTAssertNotNil(interactor.taskManager, "TaskManager not initialized in Interactor")
    }
    
    func testModuleDependencies() {
        // When
        let viewController = TaskListModuleBuilder.build() as! TaskListViewController
        guard let presenter = viewController.presenter as? TaskListPresenter,
              let interactor = presenter.interactor as? TaskListInteractor,
              let router = presenter.router as? TaskListRouter else {
            XCTFail("Invalid module dependencies")
            return
        }
        
        XCTAssertTrue(presenter.view === viewController,
                      "Presenter must have a strong reference to View")
        
        XCTAssertNotNil(presenter.interactor,
                        "Presenter must have a reference to Interactor")
        
        XCTAssertNotNil(presenter.router,
                        "Presenter must have a reference to Router")
        
        XCTAssertTrue(router.view === viewController,
                      "Router должен иметь weak ссылку на ViewController")
        
        XCTAssertNotNil(interactor.taskManager,
                        "Interactor must have a reference to TaskManager")
    }
}
