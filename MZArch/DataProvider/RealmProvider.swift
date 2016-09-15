//
//  RealmProvider.swift
//  MZArch
//
//  Created by Jamin on 4/17/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation
import RealmSwift


public class RealmProvider {
    
    public let realmQueue: dispatch_queue_t = dispatch_create_serial_queue(String(RealmProvider.self))
    public var config: Realm.Configuration;
    public var realm: Realm {
        get {
            return try! Realm(configuration: self.config);
        }
    };
    
    public init(fileURL fileUrl: NSURL) throws {
        let dir = FileUtils.appDir;
        if !NSFileManager.defaultManager().fileExistsAtPath(dir) {
            try NSFileManager.defaultManager().createDirectoryAtPath(dir, withIntermediateDirectories: true, attributes: nil);
        }
        
        self.config = Realm.Configuration(fileURL: NSURL(fileURLWithPath: FileUtils.appDir + "/common.realm"), schemaVersion: 1, deleteRealmIfMigrationNeeded: true);
        self.config.deleteRealmIfMigrationNeeded = true;
//        self.config.migrationBlock = { migration, oldSchemaVersion in
//            if (oldSchemaVersion < 1) {
//                // Nothing to do!
//                // Realm will automatically detect new properties and removed properties
//                // And will update the schema on disk automatically
//            }
//        };
//        self.realm = try Realm(configuration: self.config);
    }
  
    
    public func commitWrite(writeTask: (realm: Realm) -> Void) {
        self.realm.beginWrite();
        writeTask(realm: self.realm);
        try! self.realm.commitWrite();
    }
    
   
    public func commitTask(task: (realm: Realm) -> Void) {
        self.realm.beginWrite();
        task(realm: self.realm);
        try! self.realm.commitWrite();
    }
    
    
    
    public func read<T: Object>(readTask: (realm: Realm) -> Results<T>) -> Results<T> {
        var result: Results<T> = readTask(realm: self.realm);
        return result;
    }
    

    
}

