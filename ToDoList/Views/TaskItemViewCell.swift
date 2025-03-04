//
//  TaskItemCellNode.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 04.03.2025.
//

import UIKit

// MARK: - TaskItemViewCell
final class TaskItemViewCell: UITableViewCell {
    
    
    struct UIConstants {
        static let separatorHeight: CGFloat = 1
        static let imageSize: CGFloat = 24
        static let verticalPadding: CGFloat = 12
        static let textSpacing: CGFloat = 6
        static let textStackPadding: CGFloat = 8
    }
    
    static let identifier: String = {
        String(describing: TaskItemViewCell.self)
    }()
    
    private var model: TaskItem?

    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel = UILabel()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private let dateLabel = UILabel()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .TaskList.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .TaskList.background
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configurate(model: TaskItem, isLast: Bool) {
        
        let imageName = model.completed ? "ok" : "empty"
        statusImageView.image = UIImage(named: imageName)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        
        titleLabel.attributedText = NSAttributedString(string: model.title ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: UIColor.TaskList.foreground, .paragraphStyle: paragraphStyle
        ])
        
        descriptionLabel.attributedText = NSAttributedString(string: model.todo, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular), .foregroundColor: UIColor.TaskList.foreground
        ])
        
        dateLabel.attributedText = NSAttributedString(string: model.dateString, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular), .foregroundColor: UIColor.TaskList.separator
        ])
    }
}
