//
//  TaskCreationModuleBuilderTests.swift
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
        
        XCTAssertNotNil(viewController, "ViewController не создан")
        
        let presenter = viewController.presenter
        XCTAssertNotNil(presenter, "Presenter не создан")
        XCTAssertTrue(presenter is TaskCreationPresenter, "Неверный тип Presenter")
        
        guard let taskCreationPresenter = presenter as? TaskCreationPresenter else {
            XCTFail("Presenter не соответствует протоколу")
            return
        }
        
        XCTAssertNotNil(taskCreationPresenter.interactor, "Interactor не создан")
        XCTAssertTrue(taskCreationPresenter.interactor is TaskCreationInteractor, "Неверный тип Interactor")
        
        XCTAssertTrue(viewController.presenter === presenter, "Presenter не привязан к View")
        
        guard let interactor = taskCreationPresenter.interactor as? TaskCreationInteractor else {
            XCTFail("Interactor не соответствует протоколу")
            return
        }
        XCTAssertNotNil(interactor.taskManager, "TaskManager не инициализирован в Interactor")
    }
    
    func testModuleDependencies() {
        // When
        let viewController = TaskCreationModuleBuilder.build() as! TaskCreationViewController
        guard let presenter = viewController.presenter as? TaskCreationPresenter,
              let interactor = presenter.interactor as? TaskCreationInteractor else {
            XCTFail("Неверные зависимости модуля")
            return
        }
        
        XCTAssertTrue(presenter.view === viewController,
                      "Presenter должен иметь strong ссылку на View")
        
        XCTAssertNotNil(presenter.interactor,
                        "Presenter должен иметь ссылку на Interactor")
        
        XCTAssertNotNil(interactor.taskManager,
                        "Interactor должен иметь ссылку на TaskManager")
    }
}
