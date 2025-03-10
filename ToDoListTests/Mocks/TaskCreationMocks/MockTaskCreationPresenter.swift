//
//  MockTaskCreationPresenter.swift
//  ToDoListTests
//
//  Created by Владимир Амелькин on 10.03.2025.
//

@testable import ToDoList
import UIKit

// MARK: - MockTaskCreationPresenter
final class MockTaskCreationPresenter: NSObject, TaskCreationPresenterProtocol {
    var didCallViewDidLoad = false
    var updatedTitle: String?
    var didPerformTask = false
    var didDismiss = false
    
    func viewDidLoad() {
        didCallViewDidLoad = true
    }
    
    func titleDidChange(newValue title: String) {
        updatedTitle = title
    }
    
    func performCurrentTask(completion: @escaping () -> Void) {
        didPerformTask = true; completion()
    }
    
    func dismiss() {
        didDismiss = true
    }
    
    func textViewDidChange(_ textView: UITextView) {}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { true }
    func textViewDidBeginEditing(_ textView: UITextView) {}
    func textViewDidEndEditing(_ textView: UITextView) {}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { true }
}
