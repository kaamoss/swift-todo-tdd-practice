//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/16/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
    let itemManager: ItemManager = ItemManager()
    
    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "InputViewController")
                as? InputViewController {
            
            nextViewController.itemManager = self.itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }

}
