//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskListPresenterProtocol
protocol TaskListPresenterProtocol: UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, TaskListFooterOutput  {
    func viewDidLoad()
}

// MARK: - TaskListPresenter
final class TaskListPresenter: NSObject, TaskListPresenterProtocol {
    
    // MARK: Properties
    private let router: TaskListRouterProtocol
    private let interactor: TaskListInteractorProtocol
    weak var view: TaskListViewProtocol?
    
    // MARK: Init
    init(router: TaskListRouterProtocol, interactor: TaskListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: Public methods
    func viewDidLoad() {
        guard let view else { return }
        interactor.fetchData()
        view.tableView.reloadData()
        view.updateCount(with: interactor.data.count)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = interactor.data[indexPath.row]
        router.openTaskEdition(with: item, output: self)
    }
    
}

// MARK: - UISearchResultsUpdating
extension TaskListPresenter: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

// MARK: - TaskListFooterOutput
extension TaskListPresenter: TaskListFooterOutput {
    func openTaskCreation() {
        router.openTaskCreation(output: self)
    }
}

// MARK: - TaskCreationModuleOutput
extension TaskListPresenter: TaskCreationModuleOutput {
    func didFinishTaskEditing(hasChanges: Bool) {
        #warning("TODO: Получить новые данные interactor.fetchData()")
        view?.tableView.reloadData()
    }
}
