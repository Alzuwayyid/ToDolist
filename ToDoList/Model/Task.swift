//
//  Task.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import Foundation

class Task: Equatable, Codable{
    var title: String
    var isCompleted: Bool
    var isLate: Bool
    var dueDate: Date?
    var creationDate: Date
    var additionalNote: String
    var id: String
    
    var filteringTag = String()
    
    
    init(title: String, dueDate: Date?, date: Date, additionalNote: String, isCompleted: Bool, isLate: Bool, tag: String) {
        self.title = title
        self.dueDate = dueDate
        self.creationDate = date
        self.additionalNote = additionalNote
        self.isLate = isLate
        self.isCompleted = isCompleted
        self.filteringTag = tag
        self.id = UUID().uuidString
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.title == rhs.title
            && lhs.dueDate == rhs.dueDate
            && lhs.creationDate == rhs.creationDate
            && lhs.additionalNote == rhs.additionalNote
            && lhs.isLate == rhs.isLate
            && lhs.isCompleted == rhs.isCompleted
            && lhs.filteringTag == rhs.filteringTag
    }
    
}


