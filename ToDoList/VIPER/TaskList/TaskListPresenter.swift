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
    func getTask(by index: Int) -> TaskItem?
}

// MARK: - TaskListPresenter
final class TaskListPresenter: NSObject, TaskListPresenterProtocol {
    
    // MARK: Properties
    private let router: TaskListRouterProtocol
    private let interactor: TaskListInteractorProtocol
    weak var view: TaskListViewProtocol?
    
    private var tableView: UITableView? {
        view?.tableView
    }
    
    // MARK: Init
    init(router: TaskListRouterProtocol, interactor: TaskListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: Private methods
    private func didTapEditTask(by index: Int) {
        guard let task = interactor.data[safe: index] else { return }
        router.openTaskEdition(with: task, output: self)
    }
    
    private func didTapShareTask(by index: Int) {
        
    }
    
    private func didTapRemoveTask(by index: Int) {
        interactor.removeTask(by: index) { [weak self] in
            guard let self else { return }
            self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.view?.updateCount(with: self.interactor.data.count)
        }
    }
    
    // MARK: Public methods
    func viewDidLoad() {
        guard let view else { return }
        interactor.fetchData() { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                view.tableView.reloadData()
                view.updateCount(with: self.interactor.data.count)
            }
        }
    }
    
    func getTask(by index: Int) -> TaskItem? {
        return interactor.data[safe: index]
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
        if cell.output == nil {
            cell.output = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: {
            guard let item = self.interactor.data[safe: indexPath.row] else { return UIViewController() }
            let viewController = TaskItemPreviewViewController(model: item)
            return viewController
        },
                                          actionProvider: { _ in
            let editAction = UIAction(title: NSLocalizedString("Редактировать", comment: ""), image: UIImage(named: "edit")) { action in
                self.didTapEditTask(by: indexPath.row)
            }
            let shareAction = UIAction(title: NSLocalizedString("Поделиться", comment: ""), image: UIImage(named: "export")) { action in
                self.didTapShareTask(by: indexPath.row)
            }
            let removeAction = UIAction(title: NSLocalizedString("Удалить", comment: ""), image: UIImage(named: "trash"), attributes: .destructive) { action in
                self.didTapRemoveTask(by: indexPath.row)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, removeAction])
        })
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

// MARK: - TaskItemViewCellOutput
extension TaskListPresenter: TaskItemViewCellOutput {
    func didToggleTaskCompleteValue(taskId: Int) {
        interactor.toggleTaskCompleteValue(in: taskId) { [weak self] rowForUpdate in
            guard let self, let rowForUpdate else { return }
            self.view?.tableView.reloadRows(at: [IndexPath(row: rowForUpdate, section: 0)], with: .automatic)
        }
    }
}
