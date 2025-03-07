//
//  TaskListFooterView.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//
import UIKit

// MARK: - TaskListFooterOutput
protocol TaskListFooterOutput: AnyObject {
    func openTaskCreation()
}

// MARK: - TaskListFooterView
final class TaskListFooterView: UIView {
    
    // MARK: UIConstants
    private struct UIConstants {
        static let separatorHeight: CGFloat = 1
        static let countLabelTopOffset: CGFloat = 20.5
    }
    
    // MARK: Properties
    weak var output: TaskListFooterOutput?
    
    // MARK: UIProperties
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .TaskList.Element.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .TaskList.Foreground.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .TaskList.Background.second
        
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: UIConstants.separatorHeight)
        ])
        
        addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.countLabelTopOffset)
        ])
        
        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    @objc private func addButtonTapped() {
        output?.openTaskCreation()
    }
    
    // MARK: Public methods
    func updateCount(with value: Int) {
        countLabel.text = String(localized: "\(value) taskCounter")
    }
}
