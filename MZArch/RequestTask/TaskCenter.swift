//
//  TaskCenter.swift
//  MZArch
//
//  Created by Jamin on 4/10/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation
import Alamofire




public class TaskCenter {
    
    let requestManager = Alamofire.Manager.sharedInstance;

    
    public static let sharedCenter: TaskCenter = {
        return TaskCenter();
    }();
    
    
    init() {
        
        
    }
    
    
    
    
    
    func resume<Value, Error: ErrorType>(request: Request<Value, Error>) throws {
        
        var method = Method.GET;
        if let aMethod = Method(rawValue: request.HTTPMethod) {
            method = aMethod;
        }
        
        
        
        let alamofireReq = self.requestManager.request(method,
                                                       request.URL,
                                                       parameters: request.HTTPBody,
                                                       encoding: request.requestBodyEncoding.alamofireEncoding(),
                                                       headers: request.HTTPHeaders);
        switch request.responseBodyEncoding {
        case .JSON:
            alamofireReq.responseJSON(completionHandler: { (responseJSON) in
                request.handleAlamofireResponse(responseJSON);
            });
            
        default:
            alamofireReq.responseData(completionHandler: { (responseData) in
                
            })
            
        }
    }
    
    
    func suspend<Value, Error: ErrorType>(request: Request<Value, Error>) -> Bool {
        return true;
    }
    
    
    func cancel<Value, Error: ErrorType>(request: Request<Value, Error>) -> Bool {
        return true;
    }
    
    
    
    
    
    
    
    
    

    
}
