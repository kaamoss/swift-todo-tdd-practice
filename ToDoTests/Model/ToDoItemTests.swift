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
    
    func testInit_ShouldTakeTitleAndDescAndDueDateAndLocation() {
        let location = Location(name: "Test name")
        let titleStr = "Test Title"
        let descStr = "Test description"
        let dueDateVal = 0.0

        let item = ToDoItem(title: titleStr, description: descStr, dueDate: dueDateVal, location: location)
        
        XCTAssertEqual(item.location?.name, location.name, "Initializer should set the item location")
    }
    
    func testEqualItems_ShouldBeEqual() {
        let firstItem = ToDoItem(title: "Frist!")
        let secondItem = ToDoItem(title: "Frist!")
        
        XCTAssertEqual(firstItem, secondItem, "Should be the same")
    }
    
    func testWhenLocationDiffers_ShouldNotBeEqual() {
        let item1 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0, location: Location(name: "Home"))
        let item2 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0, location: Location(name: "Office"))
        
        XCTAssertNotEqual(item1, item2)
    }
    
    func testWhenOneLocationIsNilAndOtherIsnt_ShouldNotBeEqual() {
        var item1 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0, location: Location(name: "Home"))
        var item2 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0, location: nil)
        
        XCTAssertNotEqual(item1, item2)
        
        item1 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0, location: nil)
        item2 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0, location: Location(name: "Home"))
        
        XCTAssertNotEqual(item1, item2)
    }
    
    func testWhenTimestampDifferes_ShouldNotBeEqual() {
        let item1 = ToDoItem(title: "First Title", description: "First Description", dueDate: 0.0)
        let item2 = ToDoItem(title: "First Title", description: "First Description", dueDate: 1.0)
        
        XCTAssertNotEqual(item1, item2)
    }
    
    func testWhenDescriptionDifferes_ShouldNotBeEqual() {
        let item1 = ToDoItem(title: "First Title", description: "First Description")
        let item2 = ToDoItem(title: "First Title", description: "Second Description")
        
        XCTAssertNotEqual(item1, item2)
    }
    
    func testWhenTitleDifferes_ShouldNotBeEqual() {
        let item1 = ToDoItem(title: "First Title")
        let item2 = ToDoItem(title: "Second Title")
        
        XCTAssertNotEqual(item1, item2)
    }
    
    func test_CanBeSerializedAndDeserialized() {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "The Title", description: "The Description", dueDate: 1.0, location: location)
        
        let dict = item.plistDict
        XCTAssertNotNil(dict)
        XCTAssertTrue(dict is [String:Any])
        
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }
}
