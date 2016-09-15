//
//  UserDefaultsTest.swift
//  MZArch
//
//  Created by Jamin on 5/21/16.
//  Copyright © 2016 mz. All rights reserved.
//

import XCTest
import MZArch;

class UserDefaultsTest: XCTestCase {
   
    var userDefaults = UserDefaults(userId: "123");;
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetObject() {
        let num = NSNumber(int: 1);
        let key = "NumInt";
        userDefaults.setObject(num, forKey: key);
        let result = userDefaults.objectForKey(key) as? NSNumber
        XCTAssert(result == num, "Set Object(\(num)) failed with result(\(result))") ;
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
