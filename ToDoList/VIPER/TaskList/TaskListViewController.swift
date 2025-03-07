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
    
    func refreshCount(with value: Int)
}

// MARK: - TaskListViewController
final class TaskListViewController: UIViewController, TaskListViewProtocol {
    
    // MARK: UIConstants
    struct UIConstants {
        static let estimatedRowHeight: CGFloat = 90
        static let horizontalPadding: CGFloat = 20
        static let footerHeight: CGFloat = 83
    }
    
    // MARK: Properties
    private var presenter: TaskListPresenterProtocol
    
    // MARK: UIProperites
    private let searchController = UISearchController()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskItemViewCell.self, forCellReuseIdentifier: TaskItemViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .TaskList.Background.primary
        tableView.delegate = presenter
        tableView.dataSource = presenter
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UIConstants.estimatedRowHeight
        return tableView
    }()
    
    private lazy var footerView: TaskListFooterView = {
        let view = TaskListFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.output = presenter
        return view
    }()
    
    // MARK: Init
    init(presenter: TaskListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .TaskList.Background.primary
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.horizontalPadding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.horizontalPadding),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(footerView)
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: UIConstants.footerHeight)
        ])
        
        configureNavigationBar(largeTitleColor: .TaskList.Foreground.primary, backgoundColor: .TaskList.Background.primary, tintColor: .TaskList.Element.button, title: "Задачи", preferredLargeTitle: true)
        
        configureSearchController()
        presenter.viewDidLoad()
    }
    
    // MARK: Private Methods
    private func configureSearchController() {
        searchController.searchResultsUpdater = presenter
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .TaskList.Element.button
        searchController.searchBar.searchTextField.textColor = .TaskList.Element.button
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: Public Methods
    func refreshCount(with value: Int) {
        footerView.updateCount(with: value)
    }
}

