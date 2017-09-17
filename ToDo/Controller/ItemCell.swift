//
//  ItemCell.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    func configCellWithItem(item: ToDoItem, checked: Bool = false) {
        
        if checked {
            let attributedTitle = NSAttributedString(string: item.title, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
            titleLabel.attributedText = attributedTitle
            locationLabel.text = nil
            dueDateLabel.text = nil
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name
        
            if let timestamp = item.dueDate {
                let date = Date(timeIntervalSince1970: timestamp)
            
                dueDateLabel.text = dateFormatter.string(from: date)
            }
        }
    }
}
