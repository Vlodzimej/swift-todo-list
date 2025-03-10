//
//  TaskListModuleBuilderTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskCreationModuleBuilderTests
final class TaskCreationModuleBuilderTests: XCTestCase {
    
    func testModuleAssembly() {
        let viewController = TaskCreationModuleBuilder.build() as! TaskCreationViewController
        
        XCTAssertNotNil(viewController, "ViewController not created")
        XCTAssertTrue(viewController is TaskCreationViewController, "Invalid ViewController type")
        
        let presenter = viewController.presenter
        XCTAssertNotNil(presenter, "Presenter not created")
        XCTAssertTrue(presenter is TaskCreationPresenter, "Invalid Presenter type")
        
        guard let taskCreationPresenter = presenter as? TaskCreationPresenter else {
            XCTFail("Presenter does not conform to protocol")
            return
        }
        
        XCTAssertNotNil(taskCreationPresenter.router, "Router not created")
        XCTAssertTrue(taskCreationPresenter.router is TaskCreationRouter, "Invalid Router type")
        
        XCTAssertNotNil(taskCreationPresenter.interactor, "Interactor not created")
        XCTAssertTrue(taskCreationPresenter.interactor is TaskCreationInteractor, "Invalid Interactor type")
        
        guard let router = taskCreationPresenter.router as? TaskCreationRouter else {
            XCTFail("Router не соответствует протоколу")
            return
        }
        XCTAssertTrue(router.view === viewController, "Router не имеет ссылки на ViewController")
        
        XCTAssertTrue(viewController.presenter === presenter, "Presenter не привязан к View")
        
        guard let interactor = taskCreationPresenter.interactor as? TaskCreationInteractor else {
            XCTFail("Interactor does not conform to protocol")
            return
        }
        XCTAssertNotNil(interactor.taskManager, "TaskManager not initialized in Interactor")
    }
    
    func testModuleDependencies() {
        // When
        let viewController = TaskCreationModuleBuilder.build() as! TaskCreationViewController
        guard let presenter = viewController.presenter as? TaskCreationPresenter,
              let interactor = presenter.interactor as? TaskCreationInteractor,
              let router = presenter.router as? TaskCreationRouter else {
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
                      "Router must have a weak reference to ViewController")
        
        XCTAssertNotNil(interactor.taskManager,
                        "Interactor must have a reference to TaskManager")
    }
}
