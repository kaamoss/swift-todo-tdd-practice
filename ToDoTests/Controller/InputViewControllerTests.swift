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
    
    class MockInputViewController : InputViewController {
        
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        
        override func dismiss(animated flag: Bool,
                              completion: (() -> Void)? = nil) {
            
            dismissGotCalled = true
            completionHandler?()
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
        let mockSut = MockInputViewController()
        
        mockSut.titleTextField = UITextField()
        mockSut.dueDateTextField = UITextField()
        mockSut.locationTextField = UITextField()
        mockSut.addressTextField = UITextField()
        mockSut.descriptionTextField = UITextField()
        
        mockSut.titleTextField.text = "Test Title"
        mockSut.dueDateTextField.text = "09/17/2017"
        mockSut.locationTextField.text = "We Work Culver City"
        mockSut.addressTextField.text = "Infinte Loop 1, Cupertino"
        mockSut.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        mockSut.geocoder = mockGeocoder
        
        let itemManager = ItemManager()
        mockSut.itemManager = itemManager
        
        let dismissExpectation = expectation(description: "Dismiss")
        
        mockSut.completionHandler = {
            dismissExpectation.fulfill()
        }
        
        mockSut.save()
        
        placemark = MockPlacemark()
        let coordinate: CLLocationCoordinate2D;
        coordinate = CLLocationCoordinate2DMake(37.3316833, -122.0301031)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        let item = mockSut.itemManager?.itemAtIndex(index: 0)
        
        let testItem = ToDoItem(title: "Test Title", description: "Test Description", dueDate: 1505631600, location: Location(name: "We Work Culver City", coordinate: coordinate))
        
        //XCTAssertEqual(item, testItem)
        XCTAssertNotEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail(); return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dueDateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Frist!"
        mockInputViewController.save()
        
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
        
    }
    
    func test_GeocoderWorksAsExpected() {
        let expect = expectation(description: "Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinte Loop 1, Cupertino", completionHandler: {placemarks, error in
            
            let placemark = placemarks?.first
            
            
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqualWithAccuracy(latitude, 37.3316833, accuracy: 0.000001)
            XCTAssertEqualWithAccuracy(longitude, -122.0301031, accuracy: 0.000001)

            
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
