//
//  DBConnectionCache.swift
//  MZArch
//
//  Created by Jamin on 5/17/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation
import SQLite


public class ConnectionInfo {
    
    var db: Connection;
    var dbPath: String;
    
    private var tableVersionsMap: [String : Int] = [:];
    private var retainCount: Int32 = 1;
    private var semaphore: dispatch_semaphore_t = dispatch_semaphore_create(1);
    
    
    init(dbPath path: String) throws {
        dbPath = path;
        db = try Connection(path);
        self.tableVersionsMap = try loadTableVersion(db: db);
    }
    
    
    func loadTableVersion(db aDb: Connection) throws -> [String: Int] {
        
        var versionsMap: [String: Int] = [:];
        let tbVersions = Table("table_versions")
        let name = Expression<String>("name")
        let version = Expression<Int>("version")
        
        try aDb.run(tbVersions.create(ifNotExists: true) { t in
            t.column(name, primaryKey: true)
            t.column(version)
            })
        //            try self.db.execute("CREATE TABLE IF NOT EXISTS \"table_versions\" ("
        //                + "name TEXT PRIMARY KEY, "
        //                + "version INTEGER DEFAULT 0);")
        
        
        for table in try self.db.prepare(tbVersions) {
            versionsMap[table[name]] = table[version];
        }
        
        return versionsMap;
    }
    
    
    func version(table tableName: String) -> Int? {
        
        var ver: Int?;
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        ver = self.tableVersionsMap[tableName];
        dispatch_semaphore_signal(semaphore);
        
        return ver;
    }

    func updateVersion(table tableName: String, version ver: Int) -> Bool {
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        self.tableVersionsMap[tableName] = ver;
        dispatch_semaphore_signal(semaphore);
        
        let tbVersions = Table("table_versions");
        let name = Expression<String>("name");
        let version = Expression<Int>("version");
        
        
        do {
            let alice = tbVersions.filter(name == tableName);
            return (try self.db.run(alice.update(version <- ver)) > 0);
            
        } catch {
            return false;
        }
    }
    
    
    func increaseRetain() -> Int32 {
        return OSAtomicIncrement32Barrier(&retainCount);
    }
    
    func decreaseRetain() -> Int32 {
        return OSAtomicDecrement32Barrier(&retainCount);
    }
    

    
}


public class DBConnectionCache {

    
    static var sDBCache: [String: ConnectionInfo] = [:];
    static var sSemaphore: dispatch_semaphore_t = dispatch_semaphore_create(1);
    
    public class func reuse(dbPath path: String) throws -> ConnectionInfo {
        
        let dirPath = NSString(string: path).stringByDeletingLastPathComponent;
        var isDir = ObjCBool(false);
        if (!NSFileManager.defaultManager().fileExistsAtPath(dirPath, isDirectory: &isDir) || !isDir) {
            try NSFileManager.defaultManager().createDirectoryAtPath(dirPath, withIntermediateDirectories: true, attributes: nil);
        }
        
        
        var conectionInfo: ConnectionInfo;
        
        dispatch_semaphore_wait(sSemaphore, DISPATCH_TIME_FOREVER);
        if let dbConInfo = DBConnectionCache.sDBCache[path] {
            conectionInfo = dbConInfo;
            dbConInfo.increaseRetain();
        } else {
            conectionInfo = try ConnectionInfo(dbPath: path);
            DBConnectionCache.sDBCache[path] = conectionInfo;
        }
        dispatch_semaphore_signal(sSemaphore);
        
        return conectionInfo;
    }
    
    
    class func release(dbPath path: String) {
        if let dbConInfo = DBConnectionCache.sDBCache[path] {
            dbConInfo.decreaseRetain();
            
            if dbConInfo.decreaseRetain() <= 0 {
                DBConnectionCache.sDBCache[path] = nil;
            }
        }
    }
    
}


