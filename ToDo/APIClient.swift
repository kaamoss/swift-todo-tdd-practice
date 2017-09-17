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

extension URLSession : ToDoURLSession { }

class APIClient {
    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager: KeychainAccessible?
    
    func loginUserWithName(username: String, password: String, completion: @escaping (Error?) -> Void) {
    
        let allowedCharacters = CharacterSet(
            charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let encodedUsername = username.addingPercentEncoding(
            withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        guard let encodedPassword = password.addingPercentEncoding(
            withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        guard let url = URL(string: "https://secure.last.fm/login?username=\(encodedUsername)&password=\(encodedPassword)") else { fatalError() }
        session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completion(WebserviceError.ResponseError)
                return
            }
            guard let data = data else {
                completion(WebserviceError.DataEmptyError)
                return
            }
            
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
                
                let token = responseDict["token"] as! String
                self.keychainManager?.setPassword(password: token, account: "token")
            } catch {
                completion(error)
            }
            
        }.resume()
    }
}

enum WebserviceError : Error {
    case DataEmptyError
    case ResponseError
}
