//
//  RequestProtocol.swift
//  MZArch
//
//  Created by Jamin on 4/17/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation



public protocol RequestProtocol {
    
    associatedtype Value
    associatedtype Error: ErrorType
    
    associatedtype RequestCompletionHandler;
    
    //NSURLRequest
    var urlRequest: NSURLRequest? { get };
    
    //An MZResponse object encapsulates the NSURLResponse and URL content data，provider data parsor handler
    var response: Response<Value, Error>? { get set };
    
    
//    var completionHandler: RequestCompletionHandler { get set };
    
   
    //MARK: Request Component
    var HTTPMethod: String { get set }
    
    var URL: NSURL { get set }
    
    var HTTPHeaders: [String: String]? { get set }
    
    var HTTPBody: [String: AnyObject]? { get set }
    
    
}