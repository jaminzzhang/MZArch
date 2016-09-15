//
//  SQLiteProvider.swift
//  MZArch
//
//  Created by Jamin on 5/8/16.
//  Copyright © 2016 mz. All rights reserved.
//

import UIKit
import SQLite



public enum DBScheme {
    case Common
    case User(String)
    case UserDefault(String)
   
    
    public func path() -> String {
        switch self {
        case .Common:
            return FileUtils.appDir + "/common.db";
            
        case .User(let uId):
            return FileUtils.userDir(userId: uId) + "/user.db";
            
        case .UserDefault(let uId):
            return FileUtils.userDir(userId: uId) + "/ud.db";
        }
    }
}



public class SQLiteProvider: DBProvider {
   
    let dbConnInfo: ConnectionInfo;
    var db: Connection {
        get {
            return dbConnInfo.db;
        }
    }
    
    
    init(scheme aScheme: DBScheme) throws {
        dbConnInfo = try DBConnectionCache.reuse(dbPath: aScheme.path());
        if nil == self.version {
            try self.onCreateTable();
        }
    }
    
    
    init(dbPath path: String) throws {
        dbConnInfo = try DBConnectionCache.reuse(dbPath: path);
        if nil == self.version {
            try self.onCreateTable();
        }
    }
    
    deinit {
        DBConnectionCache.release(dbPath: dbConnInfo.dbPath);
    }
    
    
    
    //MARK: - DBProvider
    public var tableName: String {
        get {
            return "Common";
        }
    };
    
    
    
    public var version: Int? {
        get {
            return dbConnInfo.version(table: self.tableName);
        }
    }
    
    
    
    public func onUpgrade(fromVersion fVer: Int, toVersion tVer: Int) throws {
        
    }
    
    
    public func onCreateTable() throws {
        
    }
    
    
    
}
