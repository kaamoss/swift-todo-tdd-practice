//
//  ToDoItem.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import Foundation

struct ToDoItem {
    let title: String
    let description: String?
    let dueDate: Double?
    
    init(title: String, description: String? = nil, dueDate: Double? = nil) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
    }
    
}