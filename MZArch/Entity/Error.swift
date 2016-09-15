//
//  Error.swift
//  MZArch
//
//  Created by Jamin on 4/17/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation



public class Error: ErrorType {
    public let code: Int;
    
    
    
    public init(code: Int) {
        self.code = code;
    }
    
    
    public static let defaultError = Error(code: -1);
    
}