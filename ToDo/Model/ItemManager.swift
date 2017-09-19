//
//  ItemManager.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import Foundation

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    func addItem(item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }
    
    func itemAtIndex(index: Int) -> ToDoItem {
        if(index < toDoCount) {
            return toDoItems[index]
        }
        return ToDoItem(title: "")
    }
    
    func doneItemAtIndex(index: Int) -> ToDoItem {
        if(index < doneCount) {
            return doneItems[index]
        }
        return ToDoItem(title: "")
    }
    
    func checkItemAtIndex(index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func uncheckItemAtIndex(index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }
    
    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
}
