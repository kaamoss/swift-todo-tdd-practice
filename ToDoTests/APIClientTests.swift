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
        var dataTask = MockURLSessionDataTask()
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            self.url = url
            self.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockURLSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
    }
    
    class MockKeychainManager : KeychainAccessible {
        var passwordDict = [String:String]()
        
        func setPassword(password: String, account: String) {
            passwordDict[account] = password
        }
        
        func deletePasswordForAccount(account: String) {
            passwordDict.removeValue(forKey: account)
        }
        
        func passwordForAccount(account: String) -> String? {
            return passwordDict[account]
        }
    }
}

class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword() {
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "dasdöm", password: "dictionary&Attack", completion: completion)
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url,
                                          resolvingAgainstBaseURL: true)
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = CharacterSet(
            charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let expectedUsername = "dasdöm".addingPercentEncoding(
            withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        guard let expectedPassword = "dictionary&Attack".addingPercentEncoding(
            withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        XCTAssertEqual(urlComponents?.percentEncodedQuery,
                       "username=\(expectedUsername)&password=\(expectedPassword)")
    }
    
    func testLogin_CallsResumeOfDataTask() {        
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "dasdöm", password: "dictionary&Attack", completion: completion)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testLogin_SetsToken() {
        
        let mockKeychainManager = MockKeychainManager()
        sut.keychainManager = mockKeychainManager
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName(username: "dasdöm", password: "dictionary&Attack", completion: completion)
        
        let responseDict = ["token" : "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        mockURLSession.completionHandler?(responseData, nil, nil)
        
        let token = mockKeychainManager.passwordForAccount(account: "token")
        XCTAssertEqual(token, responseDict["token"])
    }
}
