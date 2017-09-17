//
//  InputViewController.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/17/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var itemManager: ItemManager?
    lazy var geocoder = CLGeocoder()
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.characters.count > 0 else { return }
        
        let date: Date?
        if let dueDateText = self.dueDateTextField.text, dueDateText.characters.count > 0 {
            date = dateFormatter.date(from: dueDateText)
        } else {
            date = nil
        }
        
        let descString: String?
        if (descriptionTextField.text?.characters.count)! > 0 {
            descString = descriptionTextField.text
        } else {
            descString = nil
        }
        
        if let locationName = locationTextField.text, locationName.characters.count > 0 {
            if let address = addressTextField.text, address.characters.count > 0 {
                
                geocoder.geocodeAddressString(address, completionHandler: {
                    [unowned self] (placeMarks, error) -> Void in
                    
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(title: titleString, description: descString, dueDate: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))
                    
                    self.itemManager?.addItem(item: item)
                })
            }
        }
    }
}
