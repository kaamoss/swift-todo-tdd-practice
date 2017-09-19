//
//  ItemListDataProviderTests.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest
@testable import ToDo

extension ItemListDataProviderTests {
    class MockTableView : UITableView {
        var cellGotDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        class func mockTableViewWith(dataSource: UITableViewDataSource) -> MockTableView {
            
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            return mockTableView
        }
    }
    
    class MockItemCell : ItemCell {
        
        var toDoItem: ToDoItem?
        
        override func configCellWithItem(item: ToDoItem, checked: Bool) {
            toDoItem = item
        }
    }
}

class ItemListDataProviderTests: XCTestCase {
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        _ = controller.view
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumberOfSections_IsTwo() {
        let numSections = tableView.numberOfSections
        XCTAssertEqual(numSections, 2)
    }
    
    func testNumberOfRowsInFirstSection_IsToDoCount() {
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.itemManager?.addItem(item: ToDoItem(title: "Second"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSecondSection_IsDoneCount() {
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        sut.itemManager?.addItem(item: ToDoItem(title: "Second"))
        sut.itemManager?.checkItemAtIndex(index: 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.itemManager?.checkItemAtIndex(index: 0)
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRow_ReturnsItemCell() {
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is ItemCell)
    }
    
    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView.mockTableViewWith(dataSource: sut)
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testConfigCell_GetsCalledInCellForRow() {
        let mockTableView = MockTableView.mockTableViewWith(dataSource: sut)
        
        let toDoItem = ToDoItem(title: "First Item", description: "First description text")
        sut.itemManager?.addItem(item: toDoItem)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.toDoItem, toDoItem)
    }
    
    func testCellInSectionTwo_GetsConfiguredWithDoneItem() {
        let mockTableView = MockTableView.mockTableViewWith(dataSource: sut)
        
        let firstItem = ToDoItem(title: "First Item", description: "First description text")
        sut.itemManager?.addItem(item: firstItem)
        
        let secondItem = ToDoItem(title: "Second Item", description: "Second description text")
        sut.itemManager?.addItem(item: secondItem)
        
        sut.itemManager?.checkItemAtIndex(index: 1)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        
        XCTAssertEqual(cell.toDoItem, secondItem)
    }
    
    func testDeletionButtonInFirstSection_ShowsTitleCheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(deleteButtonTitle, "Check")
    }
    
    func testDeletionButtonInSecondSection_ShowsTitleUncheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }
    
    func testCheckingAnItem_ChecksItInItemManager() {
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }
    
    func testUncheckingAnItem_UnchecksItInItemManager() {
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        sut.itemManager?.checkItemAtIndex(index: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }
    
    func testSelectingACell_SendsNotification() {
        let item = ToDoItem(title: "First")
        sut.itemManager?.addItem(item: item)
        
        expectation(forNotification: "ItemSelectedNotification", object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else { return false }
            return index == 0
        }
        
        tableView.delegate?.tableView!(
            tableView,
            didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 3, handler: nil)
        
    }
    
}
