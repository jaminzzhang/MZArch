//
//  NSCacheExtension.swift
//  MZArch
//
//  Created by Jamin on 6/11/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation


public extension NSCache {
    subscript(key: AnyObject) -> AnyObject? {
        get {
            return objectForKey(key)
        }
        set {
            if let value: AnyObject = newValue {
                setObject(value, forKey: key)
            } else {
                removeObjectForKey(key)
            }
        }
    }
}
