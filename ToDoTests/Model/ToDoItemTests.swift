//
//  ToDoItemTests.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_ShouldTakeTitle() {
        let expectedStr = "Test Title"
        let item = ToDoItem(title: expectedStr)
        XCTAssertEqual(item.title, expectedStr, "Initializer should set the item title")
    }
    
    
    func testInit_ShouldTakeTitleAndDesc() {
        let expectedTitleStr = "Another Test Title"
        let expectedDescStr = "Test description text which might give the user a little bit more detail about exactly what they're supposed \"ToDo\""
        let item = ToDoItem(title: expectedTitleStr,
                     description: expectedDescStr)
        XCTAssertEqual(item.title, expectedTitleStr, "Initializer should set the item title")
        XCTAssertEqual(item.description, expectedDescStr, "Initializer should set the item description")
    }
    
    func testInit_ShouldTakeTitleAndDescAndDueDate() {
        let titleStr = "Test Title"
        let descStr = "Test description"
        let dueDateVal = 0.0
        
        let item = ToDoItem(title: titleStr, description: descStr, dueDate: dueDateVal)
        XCTAssertEqual(item.dueDate, dueDateVal, "Initializer should set the item due date")
    }
    
}
