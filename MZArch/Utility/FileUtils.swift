//
//  FileUtils.swift
//  MZArch
//
//  Created by Jamin on 5/8/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation

public enum File {
    
}

public struct FileUtils {
    
    public static let documentDir: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!;
    
    public static let cachesDir: String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!;
    
    public static let libraryDir: String = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first!;
    
    public static let appDir: String = libraryDir + "/" + (NSBundle.mainBundle().bundleIdentifier)!;
    
    public static func userDir(userId uId: String) -> String {
        return appDir + "/" + uId;
    }
    
    
    public static func setUp() {
        var isDir = false;
        if NSFileManager.defaultManager().fileExistsAtPath(FileUtils.appDir) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(FileUtils.appDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
    }
    
    
    
    
    
}
