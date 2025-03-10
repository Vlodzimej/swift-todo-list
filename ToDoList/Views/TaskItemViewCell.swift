//
//  TaskItemCellNode.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskItemViewCellOutput
protocol TaskItemViewCellOutput: AnyObject {
    func didToggleTaskCompleteValue(taskId: Int)
}

// MARK: - TaskItemViewCell
final class TaskItemViewCell: UITableViewCell {
    
    // MARK: UIConstants
    struct UIConstants {
        static let separatorHeight: CGFloat = 1
        static let imageSize: CGFloat = 24
        static let verticalPadding: CGFloat = 12
        static let textSpacing: CGFloat = 6
        static let textStackPadding: CGFloat = 8
    }
    
    // MARK: Properties
    weak var output: TaskItemViewCellOutput?
    
    private var taskId: Int? = nil
    
    static let identifier: String = {
        String(describing: TaskItemViewCell.self)
    }()
    
    // MARK: UIProperties
    lazy var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStatusIcon)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let titleLabel = UILabel()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    let dateLabel = UILabel()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .TaskList.Element.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .TaskList.Background.primary
        selectionStyle = .none
        
        addSubview(statusImageView)
        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.verticalPadding),
            statusImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: UIConstants.imageSize),
            statusImageView.heightAnchor.constraint(equalToConstant: UIConstants.imageSize)
        ])
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.distribution = .equalSpacing
        textStackView.spacing = UIConstants.textSpacing
        
        addSubview(textStackView)
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.verticalPadding),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textStackView.leadingAnchor.constraint(equalTo: self.statusImageView.trailingAnchor, constant: UIConstants.textStackPadding),
            textStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.verticalPadding)
        ])
        
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: UIConstants.separatorHeight)
        ])
        
        contentView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        dateLabel.attributedText = nil
        statusImageView.image = nil
        taskId = nil
    }
    
    // MARK: Private Methods
    @objc private func didTapStatusIcon() {
        guard let taskId else { return }
        output?.didToggleTaskCompleteValue(taskId: taskId)
    }
    
    // MARK: Public methods
    func configurate(model: TaskItem, isLast: Bool) {
        taskId = model.id
        
        // Иконка статуса
        let imageName = model.completed ? "ok" : "empty"
        statusImageView.image = UIImage(named: imageName)
        
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
        
        titleLabel.attributedText = titleAttributedString
        
        // Описание
        descriptionLabel.attributedText = NSAttributedString(string: model.todo, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: model.completed ? UIColor.TaskList.Foreground.second : UIColor.TaskList.Foreground.primary
        ])
        
        // Дата
        dateLabel.attributedText = NSAttributedString(string: model.date ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular), .foregroundColor: UIColor.TaskList.Foreground.second
        ])
        
        // Разделитель
        separatorView.isHidden = isLast
    }
}
