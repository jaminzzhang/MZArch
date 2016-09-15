//
//  Result.swift
//  MZArch
//
//  Created by Jamin on 4/12/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation

public enum Result<Value, Error: ErrorType> {
    case Success(Value)
    case Failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true;
        default:
            return false
        }
    }
    
    
    public var value: Value? {
        switch self {
        case .Success(let value):
            return value;
            
        case .Failure:
            return nil;
        }
    }
    
    
    
    public var error: Error? {
        switch self {
        case .Success:
            return nil;
        case .Failure(let error):
            return error;
        }
    }
    
}

extension Result: CustomStringConvertible {
    
    /// A textual representation of `self`.
    public var description: String {
        switch self {
        case .Success:
            return "SUCCESS"
        
        case .Failure:
            return "FAILURE"
        }
    }
    
}



extension Result: CustomDebugStringConvertible {
    
    /// A textual representation of `self`.
    public var debugDescription: String {
        switch self {
        case .Success:
            return "SUCCESS: \(value)"
            
        case .Failure:
            return "FAILURE \(error)"
        }
    }
    
}







