//
//  UserDefaults.swift
//  MZArch
//
//  Created by Jamin on 4/27/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation

/// UserDefaults can be used to cache and store the data that will be using in the whole application lifecycle.
/// UserDefaults is not a LRU Cache, it just synchronize data between memory cache and disk storage.
public class UserDefaults {
    
    
    var cacheMap: [String: AnyObject] = [:];
    let userId: String;
    let memQueue: dispatch_queue_t;   //memory quque
    let cacheQueue: dispatch_queue_t;
//    var cacheQueue: dispatch_queue_t {
//        get {
//            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        }
//    };   //Cache quque
    
    let udProvider: UserDefaultsDBProvider;
    
    
    public init(userId uId: String) {
        self.userId = uId;
        memQueue = dispatch_create_concurrent_queue("UD\(uId)");
        cacheQueue = dispatch_create_concurrent_queue("UD\(uId)");
        udProvider = UserDefaultsDBProvider(userId: uId)!;
    }
    
    class public func sharedDefaults() -> UserDefaults {
        return UserDefaults(userId: "Share");
    }
    
    
    //MARK: - Public
    
    /*!
     -objectForKey: will search the receiver's search list for a default with the key 'defaultName' and return it. If another process has changed defaults in the search list, NSUserDefaults will automatically update to the latest values. If the key in question has been marked as ubiquitous via a Defaults Configuration File, the latest value may not be immediately available, and the registered value will be returned instead.
     */
    public func objectForKey(defaultName: String) -> AnyObject? {
        
        var result: AnyObject? = nil;
        dispatch_sync_in_queue(memQueue) {
            result = self.cacheMap[defaultName];
        }
        
        if nil == result {
            result = self.udProvider.objectForKey(defaultName);
            var cachedObj: AnyObject = NSNull();
            if (result != nil) {
                cachedObj = result!;
            }
            self.setObject(cachedObj, forKey: defaultName, isDiskCache: false);
        }
        
        
        if result is NSNull {
            return nil;
        }
        
        return result;
    }
    
    
    public func setObject(value: AnyObject?, forKey defaultName: String, isDiskCache cache: Bool = true) {
        dispatch_barrier_async_in_queue(memQueue) {
            self.cacheMap[defaultName] = value;
        }
        
        
        if cache {
            if let codingValue = value as? NSCoding {
                dispatch_async(cacheQueue, {
                    self.udProvider.setObject(codingValue , forKey: defaultName);
                })
            } else {
                assert(false, "Value \(value) should be coding");
            }
        }
    }
    
    /**
     -removeObjectForKey: is equivalent to setObject(value:nil, forKey:defaultName)
     - parameter defaultName:
     */
    public func removeObjectForKey(defaultName: String) {
        self.setObject(nil, forKey: defaultName);
    }
    
    /// -stringForKey: is equivalent to -objectForKey:
    public func stringForKey(defaultName: String) -> String? {
        return self.objectForKey(defaultName) as? String;
    }
    
    /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
    public func arrayForKey(defaultName: String) -> [AnyObject]? {
        return self.objectForKey(defaultName) as? [AnyObject];
    }
    
    public func dictionaryForKey(defaultName: String) -> [String : AnyObject]? {
        return self.objectForKey(defaultName) as? [String : AnyObject];
    }
    
    public func dataForKey(defaultName: String) -> NSData? {
        return self.objectForKey(defaultName) as? NSData;
    }
    
    
    public func stringArrayForKey(defaultName: String) -> [String]? {
        return self.objectForKey(defaultName) as? [String];
    }
    
    /*!
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    public func integerForKey(defaultName: String) -> Int {
        if let valueNumber = self.objectForKey(defaultName) as? NSNumber {
            return valueNumber.integerValue;
        }
        
        return 0;
    }
    
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    public func floatForKey(defaultName: String) -> Float {
        if let valueNumber = self.objectForKey(defaultName) as? NSNumber {
            return valueNumber.floatValue;
        }
        
        return 0.0;
    }
    
    
    /// -doubleForKey: is similar to -doubleForKey:, except that it returns a double, and boolean values will not be converted.
    public func doubleForKey(defaultName: String) -> Double {
        if let valueNumber = self.objectForKey(defaultName) as? NSNumber {
            return valueNumber.doubleValue;
        }
        
        return 0.0;
    }
    
    /*!
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    public func boolForKey(defaultName: String) -> Bool {
        if let valueNumber = self.objectForKey(defaultName) as? NSNumber {
            return valueNumber.boolValue;
        }
        
        return false;
    }
    
    
    /*!
     -URLForKey: is equivalent to -objectForKey: except that it converts the returned value to an NSURL. If the value is an NSString path, then it will construct a file URL to that path. If the value is an archived URL from -setURL:forKey: it will be unarchived. If the value is absent or can't be converted to an NSURL, nil will be returned.
     */
    public func URLForKey(defaultName: String) -> NSURL? {
        return self.objectForKey(defaultName) as? NSURL;
    }
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    public func setInteger(value: Int, forKey defaultName: String) {
        self.setObject(NSNumber(long: value), forKey: defaultName);
    }
    
    
    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    public func setFloat(value: Float, forKey defaultName: String) {
        self.setObject(NSNumber(float: value), forKey: defaultName);
    }
    
    
    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    public func setDouble(value: Double, forKey defaultName: String) {
        self.setObject(NSNumber(double: value), forKey: defaultName);
    }
    
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    public func setBool(value: Bool, forKey defaultName: String) {
        self.setObject(NSNumber(bool: value), forKey: defaultName);
    }
    
}










