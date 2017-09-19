//
//  Location.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import Foundation
import CoreLocation

struct Location : Equatable {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"
    var plistDict: [String:Any] {
        var dict = [String:Any]()
        
        dict[nameKey] = name
        
        if let coord = coordinate {
            dict[latitudeKey] = coord.latitude
            dict[longitudeKey] = coord.longitude
        }
        return dict
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
    
    init?(dict: [String:Any]) {
        guard let name = dict[nameKey] as? String else { return nil }
        
        let coord: CLLocationCoordinate2D?
        if let latitude = dict[latitudeKey] as? Double,
            let longitude = dict[longitudeKey] as? Double {
            coord = CLLocationCoordinate2DMake(latitude, longitude)
            
        } else {
            coord = nil
        }
        
        self.name = name
        self.coordinate = coord
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        
        if lhs.coordinate?.latitude != rhs.coordinate?.latitude
            || lhs.coordinate?.longitude != rhs.coordinate?.longitude {
            return false
        }
        
        if lhs.name != rhs.name {
            return false
        }
 
        return true
    }
}
