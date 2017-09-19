//
//  LocationTests.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_ShouldSetName() {
        let expectedStr = "My Test nombre es..."
        let location = Location(name: expectedStr)
        
        XCTAssertEqual(location.name, expectedStr, "Initializer should set name")
    }
    
    func testInit_ShouldSetNameAndCoordinate() {
        let testCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "",
                                coordinate: testCoordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, testCoordinate.latitude, "Initializer should set latitude")
        XCTAssertEqual(location.coordinate?.longitude, testCoordinate.longitude, "Initializer should set longitutde")
    }
    
    func testEqualLocations_ShouldBeEqual() {
        let firstLocation = Location(name: "Home")
        let secondLocation = Location(name: "Home")
        
        XCTAssertEqual(firstLocation, secondLocation)
    }
    
    func testWhenLatitudeDifferes_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProps(firstName: "Home", secondName: "Home", firstLatLng: (1.0, 0.0), secondLatLng: (0.0, 0.0))
    }
    
    func testWhenLongitudeDifferes_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProps(firstName: "Home", secondName: "Home", firstLatLng: (0.0, 1.0), secondLatLng: (0.0, 0.0))
    }
    
    func testWhenOneHasCoordAndOtherDoesnt_ShouldBeNotEqual() {
        performNotEqualTestWithLocationProps(firstName: "Home", secondName: "Home", firstLatLng: (0.0, 1.0), secondLatLng: nil)
    }
    
    func testWhenNameDifferes_ShouldBeNotEqual() {
        performNotEqualTestWithLocationProps(firstName: "Home", secondName: "Office", firstLatLng: nil, secondLatLng: nil)
    }
    
    func performNotEqualTestWithLocationProps(firstName: String,
                                              secondName: String,
                                              firstLatLng: (Double, Double)?,
                                              secondLatLng: (Double, Double)?,
                                              line: UInt = #line) {
        
        let firstCoord: CLLocationCoordinate2D?
        if let firstLatLng = firstLatLng {
            firstCoord = CLLocationCoordinate2D(latitude: firstLatLng.0, longitude: firstLatLng.1)
        } else {
            firstCoord = nil
        }
        let firstLocation = Location(name: firstName, coordinate: firstCoord)
        
        let secondCoord: CLLocationCoordinate2D?
        if let secondLatLng = secondLatLng {
            secondCoord = CLLocationCoordinate2D(latitude: secondLatLng.0, longitude: secondLatLng.1)
        } else {
            secondCoord = nil
        }
        let secondLocation = Location(name: secondName, coordinate: secondCoord)
        
        XCTAssertNotEqual(firstLocation, secondLocation, line: line)
    }
    
    func test_CanBeSerializedAndDeserialized() {
        let loc = Location(name: "Home", coordinate: CLLocationCoordinate2DMake(50.0, 6.0))
        
        let dict = loc.plistDict
        XCTAssertNotNil(dict)
        
        let recreatedLoc = Location(dict: dict)
        XCTAssertEqual(recreatedLoc, loc)
    }
}
