//
//  UserRealmProvider.swift
//  MZArch
//
//  Created by Jamin on 5/29/16.
//  Copyright © 2016 mz. All rights reserved.
//

import RealmSwift

public class UserRealmProvider: RealmProvider {
    
    public let userId: String;
    
    
    public init(userId uId: String) throws {
        self.userId = uId;
        let fileURL = NSURL(fileURLWithPath: FileUtils.userDir(userId: self.userId) + "/my.realm");
        try super.init(fileURL: fileURL);
    }
    
    
    
}
