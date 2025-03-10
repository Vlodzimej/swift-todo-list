//
//  MockTaskListPresenter.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList
import UIKit

// MARK: - MockTaskListPresenter
final class MockTaskListPresenter: NSObject, TaskListPresenterProtocol {
    
    var taskCount: Int = 0
    
    var didCallViewDidLoad = false
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }
    
    // Implement other protocol requirements...
    func getTask(by index: Int) -> TaskItem? { nil }
    func updateSearchResults(for searchController: UISearchController) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func openTaskCreation() {}
    
    func showError(message: String) {}
    
}
