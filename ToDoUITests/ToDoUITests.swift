//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Matthew FitzPatrick on 9/18/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest

extension XCUIElement {
    // The following is a workaround for inputting text in the
    //simulator when the keyboard is hidden
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems["Paste"].tap()
    }
}

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        XCUIApplication().launchEnvironment = ["AutoCorrection": "Disabled"]
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        
        let titleTextField = app.textFields["Title"]
        UIPasteboard.general.string = "First Sample Task"
        titleTextField.doubleTap()
        app.menuItems["Paste"].tap()
        
        let dueDateTextField = app.textFields["Due Date"]
        UIPasteboard.general.string = "10/03/2017"
        dueDateTextField.doubleTap()
        app.menuItems["Paste"].tap()
        
        let locationNameTextField = app.textFields["Location Name"]
        UIPasteboard.general.string = "Apple HQ"
        locationNameTextField.doubleTap()
        app.menuItems["Paste"].tap()
        
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("1 Infinite Loop, Cupertino, CA 95014")
        
        let descriptionTextField = app.textFields["Description"]
        UIPasteboard.general.string = "This is some silly description text which serves no real purpose whatsoever."
        descriptionTextField.doubleTap()
        app.menuItems["Paste"].tap()
        
        app.buttons["Save"].tap()
        
        /*
        app.otherElements.containing(.navigationBar, identifier:"ToDo.ItemListView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.tap()
        */
        
        XCTAssertTrue(app.tables.staticTexts["First Sample Task"].exists)
        XCTAssertTrue(app.tables.staticTexts["10/03/2017"].exists)
        XCTAssertTrue(app.tables.staticTexts["Apple HQ"].exists)
    }
    
}
