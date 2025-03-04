//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskListPresenterProtocol
protocol TaskListPresenterProtocol: UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource  {
    func viewDidLoad()
}

// MARK: - TaskListPresenter
final class TaskListPresenter: NSObject, TaskListPresenterProtocol {
    
    private let router: TaskListRouterProtocol
    private let interactor: TaskListInteractorProtocol
    weak var view: TaskListViewProtocol?
    
    init(router: TaskListRouterProtocol, interactor: TaskListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        interactor.fetchData()
        view?.tableView.reloadData()
    }
}

extension TaskListPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = interactor.data[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskItemViewCell.identifier, for: indexPath) as? TaskItemViewCell else {
            return UITableViewCell()
        }

        let isLast = indexPath.row == interactor.data.count - 1
        cell.configurate(model: item, isLast: isLast)
        
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension TaskListPresenter: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}
