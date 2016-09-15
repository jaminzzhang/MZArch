//
//  DBProvider.swift
//  MZArch
//
//  Created by Jamin on 4/17/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation


public protocol DBProvider {
    
    var tableName: String {get};
    var version: Int? {get}
    
    
    func onUpgrade(fromVersion fVer: Int, toVersion tVer: Int) throws;
    
    
    func onCreateTable() throws;
   
    
}
