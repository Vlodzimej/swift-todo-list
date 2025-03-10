//
//  MockTaskListViewController.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList
import UIKit

// MARK: - MockTaskListView
final class MockTaskListViewController: TaskListViewProtocol {
    var presenter: TaskListPresenterProtocol
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskItemViewCell.self, forCellReuseIdentifier: TaskItemViewCell.identifier)
        return tableView
    }()
    
    var didReloadTable = false
    
    init(presenter: TaskListPresenterProtocol) {
        self.presenter = presenter
        presenter.viewDidLoad()
    }
    
    func refreshCount(with value: Int) {}
    
    func refreshTable() {
        didReloadTable = true
    }
    
    func showError(message: String) {}
    
}
