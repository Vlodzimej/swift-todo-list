//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskListViewProtocol
protocol TaskListViewProtocol: AnyObject {
    var tableView: UITableView { get }
}

// MARK: - TaskListViewController
final class TaskListViewController: UIViewController, TaskListViewProtocol {
    
    private var presenter: TaskListPresenterProtocol
    
    private let searchController = UISearchController()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskItemViewCell.self, forCellReuseIdentifier: TaskItemViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .TaskList.background
        tableView.delegate = presenter
        tableView.dataSource = presenter
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        return tableView
    }()
    
    init(presenter: TaskListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .TaskList.background
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        configureNavBar()
        configureSearchController()
        presenter.viewDidLoad()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold),
            .foregroundColor: UIColor.white
        ]
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = presenter
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
