//
//  ItemManagerTests.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class ItemManagerTests: XCTestCase {
    var sut: ItemManager!
    
    override func setUp() {
        super.setUp()
        
        sut = ItemManager()
    }
    
    override func tearDown() {
        sut.removeAllItems()
        sut = nil
        
        super.tearDown()
    }
    
    func testToDoCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.toDoCount, 0, "Initially toDo count should be 0")
    }
    
    func testToDoCount_AfterAddingOneItem_IsOne() {
        sut.addItem(item: ToDoItem(title: "Some Test Title"))
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
    }
    
    func testDoneCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.doneCount, 0, "Initially done count should be 0")
    }
    
    func testItemAtIndex_ShouldReturnPreviouslyAddedItem() {
        let item = ToDoItem(title: "Item")
        sut.addItem(item: item)
        
        let returnedItem = sut.itemAtIndex(index: 0)
        XCTAssertEqual(returnedItem.title, item.title, "Should be the same item")
    }
    
    func testCheckingItem_ChangesCountOfToDoAndDoneItems() {
        sut.addItem(item: ToDoItem(title: "First Item"))
        sut.checkItemAtIndex(index: 0)
    }
    
    func testCheckingItem_RemovesItFromTheToDoItemList() {
        let firstItem = ToDoItem(title: "Frist!")
        let secondItem = ToDoItem(title: "Seconds")
        
        sut.addItem(item: firstItem)
        sut.addItem(item: secondItem)
        
        sut.checkItemAtIndex(index: 0)
        
        let resultItem = sut.doneItemAtIndex(index: 0)
        XCTAssertEqual(resultItem.title, firstItem.title, "should be the same item")
    }
    
    func testRemoveAllItems_ShouldResultInCountsBeZero() {
        sut.addItem(item: ToDoItem(title: "First"))
        sut.addItem(item: ToDoItem(title: "Second"))
        sut.checkItemAtIndex(index: 0)
        
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
        
        sut.removeAllItems()
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 0, "doneCount should be 0")
    }
    
    func testAddngSameItem_DoesNotIncreaseCount() {
        sut.addItem(item: ToDoItem(title: "First"))
        sut.addItem(item: ToDoItem(title: "First"))
        
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 0, "doneCount should be 0")
    }
    
    func test_ToDoItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        
        let firstItem = ToDoItem(title: "First")
        itemManager!.addItem(item: firstItem)
        
        let location = Location(name: "Home", coordinate: CLLocationCoordinate2DMake(50.0, 6.0))
        let secondItem = ToDoItem(title: "Second", description: "The Description", dueDate: 1.0, location: location)
        itemManager!.addItem(item: secondItem)
        
        NotificationCenter.default.post(name: .UIApplicationWillResignActive, object: nil)
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.itemAtIndex(index: 0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(index: 1), secondItem)
    }
}
