//
//  UserDefaultsDBProvider.swift
//  MZArch
//
//  Created by Jamin on 5/21/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation
import SQLite

class UserDefaultsDBProvider: SQLiteProvider {
    
    let kUserDefaultsTable = "UserDefault";
    
    override var tableName: String {
        get {
            return kUserDefaultsTable;
        }
    }
    
    
    let tUserDefaults: Table;
    let tKey = Expression<String>("key");
    let tValue = Expression<NSData>("value");
    
    
    init?(userId uId: String) {
        do {
            tUserDefaults = Table(kUserDefaultsTable);
            try super.init(scheme: .UserDefault(uId));
        } catch {
            print("Connect failed: \(error)")
            return nil;
        }
 
    }
    
    
    
    override func onCreateTable() throws {
        
        try self.db.run(tUserDefaults.create(ifNotExists: true) { t in
            t.column(tKey, primaryKey: true)
            t.column(tValue)
            })
        
    }
    
    
    func setObject(value: NSCoding, forKey defaultName: String) {
        do {
            let vData = NSKeyedArchiver.archivedDataWithRootObject(value);
            try self.db.run(tUserDefaults.insert(or: .Replace, tKey <- defaultName, tValue <- vData));
        } catch {
           print("Connect failed: \(error)")
        }
    }
    
    func objectForKey(defaultName: String) -> AnyObject? {
        do {
            var result: AnyObject? = nil;
            let row = try self.db.pluck(tUserDefaults.filter(tKey == defaultName))
            if let valueData: NSData = row?[tValue] {
                result = NSKeyedUnarchiver.unarchiveObjectWithData(valueData);
            }
            
            return result;
            
        } catch {
            print("Connect failed: \(error)")
            return nil;
        }
    }
    
    
}