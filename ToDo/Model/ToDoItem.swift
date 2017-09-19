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
    
    private let titleKey = "titleKey"
    private let descriptionKey = "descriptionKey"
    private let dueDateKey = "dueDateKey"
    private let locationKey = "locationKey"
    var plistDict: [String:Any] {
        var dict = [String:Any]()
        
        dict[titleKey] = title
        if let desc = description {
            dict[descriptionKey] = desc
        }
        if let dueDate = dueDate {
            dict[dueDateKey] = dueDate
        }
        if let location = location {
            let locationDict = location.plistDict
            dict[locationKey] = locationDict
        }
        
        return dict
    }
    
    init(title: String, description: String? = nil, dueDate: Double? = nil, location: Location? = nil) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.location = location
    }
    
    init?(dict: [String:Any]) {
        guard let title = dict[titleKey] as? String else { return nil }
        self.title = title
        
        self.description = dict[descriptionKey] as? String
        self.dueDate = dict[dueDateKey] as? Double
        if let locationDict = dict[locationKey] as? [String:Any] {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }
    
    static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
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
