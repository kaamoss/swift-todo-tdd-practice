//
//  APIClient.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/17/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import Foundation

protocol ToDoURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class APIClient {
    lazy var session: ToDoURLSession = URLSession.shared as! ToDoURLSession
    
    func loginUserWithName(username: String, password: String, completion: (Error?) -> Void) {
    
    }
}
