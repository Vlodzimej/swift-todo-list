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
        
        XCTAssertNotNil(viewController, "ViewController не создан")
        XCTAssertTrue(viewController is TaskListViewController, "Неверный тип ViewController")
        
        let presenter = viewController.presenter
        XCTAssertNotNil(presenter, "Presenter не создан")
        XCTAssertTrue(presenter is TaskListPresenter, "Неверный тип Presenter")
        
        guard let taskListPresenter = presenter as? TaskListPresenter else {
            XCTFail("Presenter не соответствует протоколу")
            return
        }
        
        XCTAssertNotNil(taskListPresenter.router, "Router не создан")
        XCTAssertTrue(taskListPresenter.router is TaskListRouter, "Неверный тип Router")
        
        XCTAssertNotNil(taskListPresenter.interactor, "Interactor не создан")
        XCTAssertTrue(taskListPresenter.interactor is TaskListInteractor, "Неверный тип Interactor")
        
        guard let router = taskListPresenter.router as? TaskListRouter else {
            XCTFail("Router не соответствует протоколу")
            return
        }
        XCTAssertTrue(router.view === viewController, "Router не имеет ссылки на ViewController")
        
        XCTAssertTrue(viewController.presenter === presenter, "Presenter не привязан к View")
        
        guard let interactor = taskListPresenter.interactor as? TaskListInteractor else {
            XCTFail("Interactor не соответствует протоколу")
            return
        }
        XCTAssertNotNil(interactor.taskManager, "TaskManager не инициализирован в Interactor")
    }
    
    func testModuleDependencies() {
        // When
        let viewController = TaskListModuleBuilder.build() as! TaskListViewController
        guard let presenter = viewController.presenter as? TaskListPresenter,
              let interactor = presenter.interactor as? TaskListInteractor,
              let router = presenter.router as? TaskListRouter else {
            XCTFail("Неверные зависимости модуля")
            return
        }
        
        XCTAssertTrue(presenter.view === viewController,
                      "Presenter должен иметь strong ссылку на View")
        
        XCTAssertNotNil(presenter.interactor,
                        "Presenter должен иметь ссылку на Interactor")
        
        XCTAssertNotNil(presenter.router,
                        "Presenter должен иметь ссылку на Router")
        
        XCTAssertTrue(router.view === viewController,
                      "Router должен иметь weak ссылку на ViewController")
        
        XCTAssertNotNil(interactor.taskManager,
                        "Interactor должен иметь ссылку на TaskManager")
    }
}
