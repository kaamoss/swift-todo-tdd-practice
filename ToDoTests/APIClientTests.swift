//
//  APIClientTests.swift
//  ToDo
//
//  Created by Matthew FitzPatrick on 9/17/17.
//  Copyright © 2017 FitzPatrick Software. All rights reserved.
//

import XCTest
@testable import ToDo

extension APIClientTests {
    
    class MockURLSession: ToDoURLSession {
        typealias Handler = (Data?, URLResponse?
            , Error?) -> Void
        
        var completionHandler: Handler?
        var url: URL?
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            self.url = url
            self.completionHandler = completionHandler
            return URLSession.shared.dataTask(with: url)
        }
    }
}

class APIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword() {
        
        let sut = APIClient()
        
        let mockURLSession = MockURLSession()
        
        sut.session = mockURLSession
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "peter", password: "dictionaryAttack", completion: completion)
    }
}
