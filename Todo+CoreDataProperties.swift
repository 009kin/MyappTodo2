//
//  Todo+CoreDataProperties.swift
//  MyappTodo2
//
//  Created by 009kin on 2023/01/28.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var task: String?
    @NSManaged public var content: String?
    @NSManaged public var checked: Bool

}

extension Todo : Identifiable {

}
