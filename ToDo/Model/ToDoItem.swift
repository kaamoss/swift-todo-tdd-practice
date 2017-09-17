//
//  ToDoItem.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import Foundation

struct ToDoItem : Equatable {
    let title: String
    let description: String?
    let dueDate: Double?
    let location: Location?
    
    init(title: String, description: String? = nil, dueDate: Double? = nil, location: Location? = nil) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.location = location
    }
    
    static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        //if lhs.location != rhs.location {
        if lhs.location != rhs.location {
            return false
        }
        if lhs.dueDate != rhs.dueDate {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        return true
    }
}
