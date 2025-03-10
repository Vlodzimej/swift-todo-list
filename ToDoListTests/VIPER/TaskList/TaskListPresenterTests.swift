//
//  TaskListPresenterTests.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

import XCTest
@testable import ToDoList

// MARK: - TaskListPresenterTests
final class TaskListPresenterTests: XCTestCase {
    var presenter: TaskListPresenter!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!
    var mockView: MockTaskListViewController!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        
        presenter = TaskListPresenter(
            router: mockRouter,
            interactor: mockInteractor
        )
        
        mockView = MockTaskListViewController(presenter: presenter)
        presenter.view = mockView
    }
    
    func testViewDidLoadTriggersDataFetch() {
        let expectation = self.expectation(description: "Data fetch completed")
        
        mockInteractor.fetchDataStub = {
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        presenter.viewDidLoad()
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mockInteractor.didFetchData)
            XCTAssertTrue(self.mockView.didReloadTable)
        }
    }
    
    func testSearchUpdatesResults() {
        let searchController = UISearchController()
        searchController.searchBar.text = "test"
        presenter.updateSearchResults(for: searchController)
        
        XCTAssertTrue(mockInteractor.didSearch)
        XCTAssertEqual(mockInteractor.lastSearchQuery, "test")
    }
}



