//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/17/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(password: String, account: String)
    
    func deletePasswordForAccount(account: String)
    
    func passwordForAccount(account: String) -> String?
}
