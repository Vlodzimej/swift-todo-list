//
//  TaskItemCoreModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 07.03.2025.
//
//

import Foundation
import CoreData


extension TaskItemCoreModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItemCoreModel> {
        return NSFetchRequest<TaskItemCoreModel>(entityName: "TaskItemCoreModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int32
    @NSManaged public var date: String?
    
    @discardableResult
    convenience init(_ taskItem: TaskItem) {
        self.init()
        self.id = Int32(taskItem.id)
        self.title = taskItem.title
        self.todo = taskItem.todo
        self.completed = taskItem.completed
        self.userId = Int32(taskItem.userId)
        self.date = taskItem.date
    }
}

extension TaskItemCoreModel : Identifiable {

}
