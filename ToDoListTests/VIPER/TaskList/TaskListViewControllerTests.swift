//
//  TaskListViewController.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskListViewControllerTests
final class TaskListViewControllerTests: XCTestCase {
    
    var viewController: TaskListViewController!
    var mockPresenter: MockTaskListPresenter!
    var mockRouter: MockTaskListRouter!
    
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockTaskListPresenter()
        viewController = TaskListViewController(presenter: mockPresenter)
        let navigationController = UINavigationController(rootViewController: viewController)

        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewControllerHasCorrectTitle() {
        XCTAssertEqual(viewController.title, "Tasks")
    }
    
    func testTableViewConfiguration() {
        XCTAssertTrue(viewController.tableView.delegate is TaskListPresenterProtocol)
        XCTAssertTrue(viewController.tableView.dataSource is TaskListPresenterProtocol)
        
        let cell = viewController.tableView.dequeueReusableCell(
            withIdentifier: TaskItemViewCell.identifier
        )
        XCTAssertTrue(cell is TaskItemViewCell)
        
        XCTAssertEqual(viewController.tableView.estimatedRowHeight, 90)
        XCTAssertEqual(viewController.tableView.backgroundColor, .TaskList.Background.primary)
    }
    
    func testFooterViewConfiguration() {
        XCTAssertNotNil(viewController.footerView)
        XCTAssertTrue(viewController.footerView.output === mockPresenter)
    }
    
    func testNavigationBarCustomization() {
        XCTAssertNotNil(viewController.navigationController?.navigationBar.prefersLargeTitles)
        XCTAssertEqual(viewController.navigationItem.searchController?.searchBar.placeholder, "Search")
    }
    
    func testRefreshCountUpdatesFooterView() {
        let testCountOne = 1
        let testCountOther = 5
        
        viewController.refreshCount(with: testCountOne)
        XCTAssertEqual(viewController.footerView.countLabel.text, "\(testCountOne) task")
        
        viewController.refreshCount(with: testCountOther)
        XCTAssertEqual(viewController.footerView.countLabel.text, "\(testCountOther) tasks")
    }
    
    func testSearchControllerConfiguration() {
        let searchController = viewController.navigationItem.searchController!
        
        XCTAssertTrue(searchController.searchResultsUpdater === mockPresenter)
        XCTAssertFalse(searchController.obscuresBackgroundDuringPresentation)
        XCTAssertEqual(searchController.searchBar.tintColor, .TaskList.Element.button)
    }
    
    func testViewDidLoadTriggersDataFetch() {
        viewController.viewDidLoad()
        
        XCTAssertTrue(mockPresenter.didCallViewDidLoad)
    }
    
    func testErrorPresentation() {
        let expectation = self.expectation(description: "Alert presentation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let alert = self.viewController.presentedViewController as? UIAlertController else {
                XCTFail("Alert controller not presented")
                return
            }
            
            XCTAssertEqual(alert.title, "Error")
            XCTAssertEqual(alert.message, "Test error")
            expectation.fulfill()
        }
        
        viewController.showError(message: "Test error")
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
