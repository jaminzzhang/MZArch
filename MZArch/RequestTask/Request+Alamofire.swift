//
//  Request+Alamofire.swift
//  MZArch
//
//  Created by Jamin on 5/2/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation
import Alamofire

public protocol AlamofireConvertible {
    
}

extension HTTPBodyEncoding: AlamofireConvertible {
    
    public func alamofireEncoding() -> ParameterEncoding {
        switch self {
        case .Form:
            return ParameterEncoding.URLEncodedInURL;

        case .JSON:
            return ParameterEncoding.JSON;
            
        default:
//            return ParameterEncoding.Custom({ (request: URLRequestConvertible, reponseData: [String : AnyObject]?) -> (NSMutableURLRequest, NSError?) in
//                return (nil, nil);
//            })
            return ParameterEncoding.URLEncodedInURL;
        }
    }
    
}




extension Request: AlamofireConvertible {
    
    public func handleAlamofireResponse(response: Alamofire.Response<AnyObject, NSError>?) -> Response<Value, Error>? {
        return nil;
    }
    
    
}







