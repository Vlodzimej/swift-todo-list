//
//  TaskItemPreviewViewController.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import UIKit

// MARK: - TaskItemCardView
final class TaskItemPreviewViewController: UIViewController {
    
    // MARK: UIConstants
    private struct UIConstants {
        static let textStackHorizontalPadding: CGFloat = 12
        static let textStackVerticalPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let preferredHeight: CGFloat = 106
    }

    private let model: TaskItem
    
    init(model: TaskItem) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .TaskList.Background.second
        view.layer.cornerRadius = UIConstants.cornerRadius
        
        // Заголовок
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        
        
        let titleAttributedString = NSMutableAttributedString(string: model.title ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: model.completed ? UIColor.TaskList.Foreground.second : UIColor.TaskList.Foreground.primary,
            .paragraphStyle: paragraphStyle
        ])
        
        if model.completed {
            titleAttributedString.addAttribute(.strikethroughStyle,
                                               value: NSUnderlineStyle.single.rawValue,
                                               range: NSMakeRange(0, titleAttributedString.length))
        }
        
        let titleLabel = UILabel()
        titleLabel.attributedText = titleAttributedString
        
        // Описание
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        descriptionLabel.attributedText = NSAttributedString(string: model.todo, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: model.completed ? UIColor.TaskList.Foreground.second : UIColor.TaskList.Foreground.primary
        ])
        
        // Дата
        let dateLabel = UILabel()
        dateLabel.attributedText = NSAttributedString(string: model.date ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular), .foregroundColor: UIColor.TaskList.Foreground.second
        ])
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.distribution = .equalSpacing
        textStackView.spacing = TaskItemViewCell.UIConstants.textSpacing
        
        view.addSubview(textStackView)
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIConstants.textStackVerticalPadding),
            textStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIConstants.textStackHorizontalPadding),
            textStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIConstants.textStackHorizontalPadding),
            textStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIConstants.textStackVerticalPadding)
        ])
        
        preferredContentSize = .init(width: textStackView.bounds.width, height: UIConstants.preferredHeight)
    }
}
