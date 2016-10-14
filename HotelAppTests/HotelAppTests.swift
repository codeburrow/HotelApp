//
//  HotelAppTests.swift
//  HotelAppTests
//
//  Created by Konstantinos Loutas on 10/07/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import HotelApp

class HotelAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestRemoteNotification() {
        let expect = expectation(description: "waitForWebService")
        let notifRequestUrl = "https://hotelapp-web.herokuapp.com/push"
        Alamofire.request(notifRequestUrl).responseString { (response) in
            expect.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSerialiseRemoteNotificationRequestResponse() {
        let expect = expectation(description: "serialiseResponse")
        let notifRequestUrl = "https://hotelapp-web.herokuapp.com/push"
        var serverResponseString: String?
        Alamofire.request(notifRequestUrl).responseString { (response) in
            if let responseString = response.result.value {
                serverResponseString = responseString
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(serverResponseString!, "Successful Delivery!\n")
    }
    
    func testDeviceTokenRegistration() {
        let deviceToken = "5939663C6FC82848A192A745B55B82D79D841E35AA799BAAD0A279BEFEB62D65"
        let userID = "2"
        let parameters: Parameters = ["user_id": userID, "user_token": deviceToken]
        
        let expect = expectation(description: "waitForServerResponse")
        var responseJSON: JSON?
        
        Alamofire.request("http://hotelapp-web.herokuapp.com/updateUserToken", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            responseJSON = JSON(response.result.value)
            print("Response value: \(responseJSON)")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(responseJSON?["success"], true)
    }
    
}
