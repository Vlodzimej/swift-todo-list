//
//  TaskCreationViewController.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import UIKit

// MARK: - TaskCreationViewProtocol
protocol TaskCreationViewProtocol: AnyObject {
    func update(with model: TaskItem)
    func setDescriptionPlaceholder(isVisible: Bool)
}

// MARK: - TaskCreationViewController
final class TaskCreationViewController: UIViewController, TaskCreationViewProtocol {
    
    // MARK: UIConstants
    struct UIConstants {
        static let horizontalPadding: CGFloat = 20
        static let titleTextFieldHeight: CGFloat = 41
        static let titleTextFieldTopOffset: CGFloat = 8
        static let dateLabelHeight: CGFloat = 16
        static let dateLabelTopOffset: CGFloat = 8
        static let descriptionTextFielTopOffset: CGFloat = 16
        static let defaultTitleFont: CGFloat = 34
    }
    
    // MARK: Properties
    private let presenter: TaskCreationPresenterProtocol
    
    // MARK: UIProperties
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .TaskList.Foreground.primary
        textField.backgroundColor = .TaskList.Background.primary
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = presenter
        textField.placeholder = "Название"
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .TaskList.Foreground.second
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .TaskList.Foreground.primary
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .TaskList.Background.primary
        textView.delegate = presenter
        return textView
    }()
    
    // MARK: Init
    init(presenter: TaskCreationPresenterProtocol) {
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
        
        let button = UIBarButtonItem()
        button.setTitleTextAttributes([.foregroundColor: UIColor.yellow], for: .normal)
        navigationItem.backBarButtonItem = button
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.titleTextFieldTopOffset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.horizontalPadding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.horizontalPadding),
            titleTextField.heightAnchor.constraint(equalToConstant: UIConstants.titleTextFieldHeight)
        ])
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: UIConstants.dateLabelTopOffset),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.horizontalPadding),
            dateLabel.heightAnchor.constraint(equalToConstant: UIConstants.dateLabelHeight)
        ])
        
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: UIConstants.descriptionTextFielTopOffset),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.horizontalPadding),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.horizontalPadding),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func titleTextFieldDidChange() {
        guard let text = titleTextField.text else { return }
        presenter.titleDidChange(newValue: text)
    }
    
    // MARK: Public Methods
    func update(with model: TaskItem) {
        titleTextField.text = model.title
        dateLabel.text = model.dateString
        
        if model.todo.isEmpty {
            setDescriptionPlaceholder(isVisible: true)
        } else {
            descriptionTextView.text = model.todo
        }
    }
    
    func setDescriptionPlaceholder(isVisible: Bool) {
        if isVisible {
            descriptionTextView.text = "Введите описание задания"
            descriptionTextView.textColor = .TaskList.Element.placeholder
        } else {
            descriptionTextView.text = ""
            descriptionTextView.textColor = .TaskList.Foreground.primary
        }
    }
}

