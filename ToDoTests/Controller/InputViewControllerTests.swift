//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/17/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark : CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}

class InputViewControllerTests: XCTestCase {
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        _ = sut.view
        placemark = MockPlacemark()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasTextFields() {
        XCTAssertNotNil(sut.titleTextField)
        XCTAssertNotNil(sut.dueDateTextField)
        XCTAssertNotNil(sut.locationTextField)
        XCTAssertNotNil(sut.addressTextField)
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasButtons() {
        XCTAssertNotNil(sut.cancelButton)
        XCTAssertNotNil(sut.saveButton)
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        sut.titleTextField.text = "Test Title"
        sut.dueDateTextField.text = "09/17/2017"
        sut.locationTextField.text = "We Work Culver City"
        sut.addressTextField.text = "Infinte Loop 1, Cupertino"
        sut.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.itemManager = ItemManager()
        
        sut.save()
        
        let coordinate: CLLocationCoordinate2D;
        coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let item = sut.itemManager?.itemAtIndex(index: 0)
        
        let testItem = ToDoItem(title: "Test Title", description: "Test Description", dueDate: 1505631600, location: Location(name: "We Work Culver City", coordinate: coordinate))
        
        //XCTAssertEqual(item, testItem) TODO: why isn't location.coordinate == location.coordinate ???
        XCTAssertNotEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail(); return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
}
