//
//  TaskCreationPresenter.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import UIKit

// MARK: - TaskCreationPresenterProtocol
protocol TaskCreationPresenterProtocol: UITextViewDelegate, UITextFieldDelegate {
    func viewDidLoad()
    func titleDidChange(newValue title: String)
    func performCurrentTask(completion: @escaping () -> Void)
}

// MARK: - TaskCreationModuleOutput
protocol TaskCreationModuleOutput: AnyObject {
    func didFinishTaskEditing(taskItem: TaskItem?)
}

// MARK: - TaskCreationPresenter
final class TaskCreationPresenter: NSObject, TaskCreationPresenterProtocol {
    
    // MARK: Properties
    private let router: TaskCreationRouterProtocol
    private let interactor: TaskCreationInteractorProtocol
    private weak var output: TaskCreationModuleOutput?
    
    weak var view: TaskCreationViewProtocol?
    
    // MARK: Init
    init(router: TaskCreationRouterProtocol, interactor: TaskCreationInteractorProtocol, output: TaskCreationModuleOutput?) {
        self.router = router
        self.interactor = interactor
        self.output = output
    }
    
    // MARK: Public Methods
    func viewDidLoad() {
        if let task = interactor.initialTask {
            view?.update(with: task)
        } else {
            view?.setDescriptionPlaceholder(isVisible: true)
        }
    }
    
    func titleDidChange(newValue title: String) {
        interactor.update(title: title)
    }
    
    func performCurrentTask(completion: @escaping () -> Void) {
        interactor.performCurrentTask { [weak self] taskItem in
            self?.output?.didFinishTaskEditing(taskItem: taskItem)
            completion()
        }
    }
}

// MARK: - UITextViewDelegate
extension TaskCreationPresenter: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        interactor.update(todo: textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= interactor.maxDescriptionLength
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if interactor.currentTask.todo.isEmpty {
            view?.setDescriptionPlaceholder(isVisible: false)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if interactor.currentTask.todo.isEmpty {
            view?.setDescriptionPlaceholder(isVisible: true)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension TaskCreationPresenter: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= interactor.maxTitleLength
    }
}
