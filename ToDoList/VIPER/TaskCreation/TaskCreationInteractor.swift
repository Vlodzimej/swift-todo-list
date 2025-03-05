//
//  TaskCreationInteractor.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 05.03.2025.
//

import Foundation

// MARK: - TaskCreationInteractorProtocol
protocol TaskCreationInteractorProtocol {
    var item: TaskItem? { get }
    var maxTitleLength: Int { get }
    var maxDescriptionLength: Int { get }
    
    func update(title: String)
    func update(todo: String)
    func getBlank() -> TaskItem
}

// MARK: - TaskCreationInteractor
final class TaskCreationInteractor: TaskCreationInteractorProtocol {
    
    // MARK: Properties
    private(set) var item: TaskItem?
    
    var maxTitleLength: Int {
        50
    }
    
    var maxDescriptionLength: Int {
        1000
    }
    
    // MARK: Init
    init(item: TaskItem? = nil) {
        self.item = item
    }
    
    func getBlank() -> TaskItem {
        let item = TaskItem(id: 0, todo: "", completed: false, userId: 0, date: Date.now)
        self.item = item
        
        return item
    }
    
    func update(title: String) {
        item?.title = title
    }
    
    func update(todo: String) {
        item?.todo = todo
    }
    
}
