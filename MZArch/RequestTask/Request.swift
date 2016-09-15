/**
 * MZRequest.swift
 * MZArch
 *
 * Created by MZ on 2/6/16.
 * Copyright © 2016 MZ. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import Foundation

var gSeqNumber: Int64 = 0;

public enum MZHTTPMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}



public enum HTTPBodyEncoding {
    case Form
    case JSON
    case XML
    case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
    
}





public class Request<Value, Error: ErrorType> : RequestProtocol  {
    
    // MARK: - Properties
//    public typealias Value = V;
//    public typealias Error = E;
    public typealias RequestCompletionHandler = ((response: Response<Value, Error>) -> ())
    
    public var completionHandler: RequestCompletionHandler?;
    
    
    //The sequence index of request
    public let seqNum: Int64;
    
    
    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?;
    
    
    //Request Component
    public var method: MZHTTPMethod = MZHTTPMethod.GET;
    public var HTTPMethod : String {
        get {
            return self.method.rawValue;
        }
        
        set {
            if let method = MZHTTPMethod(rawValue: newValue) {
                 self.method = method
            } else {
                self.method = .GET
            }
        }
    }
    
    public var URL: NSURL;
    
    public var requestBodyEncoding: HTTPBodyEncoding = .Form;
    public var responseBodyEncoding: HTTPBodyEncoding = .JSON;
    
    public var HTTPHeaders: [String: String]?;
    
    public var HTTPBody: [String : AnyObject]?;
    
    
    //NSURLRequest
    public var urlRequest: NSURLRequest? {
        didSet {
            self.HTTPHeaders = urlRequest?.allHTTPHeaderFields;
            if let method = urlRequest?.HTTPMethod {
                self.method = MZHTTPMethod(rawValue: method)!;
            }
        }
    }
    
    //An MZResponse object encapsulates the NSURLResponse and URL content data，provider data parsor handler
    public var response: Response<Value, Error>?;
    
    
    
    
    //MARK: Initializer
    init(method: MZHTTPMethod, URL aUrl: NSURL, copletionHandler completion: RequestCompletionHandler) {
        self.seqNum = OSAtomicIncrement64(&gSeqNumber);
        self.completionHandler = completion;
        self.method = method;
        self.URL = aUrl;
        
    }
    
    convenience init(urlRequest request: NSURLRequest, copletionHandler completion: RequestCompletionHandler) {
        var method: MZHTTPMethod = .GET;
        if let httpMethod = request.HTTPMethod {
            if let mzMethod = MZHTTPMethod(rawValue: httpMethod) {
                method = mzMethod
            }
        }
        
        
        self.init(method: method, URL: request.URL!, copletionHandler: completion);
        self.urlRequest = request;
    }
    
    
    convenience init(method: MZHTTPMethod,
                     URL aUrl: NSURL,
                         httpHeaders headers: [String: String]?,
                                     httpBody bodys: [String : AnyObject]?,
                                              copletionHandler completion: RequestCompletionHandler) {
        self.init(method: method, URL: aUrl, copletionHandler: completion);
        self.HTTPHeaders = headers;
        self.HTTPBody = bodys;
        
    }
    
    
    
    
    
    //MARK: Request Component
    
    
    
    
    
    /**
     Build NSURLRequest
     
     - parameter method:   HTTPMethod
     - parameter aUrl:     Request URL
     - parameter headers:
     - parameter bodyData:
     
     - returns: NSMutableURLRequest
     */
    func URLRequest(method: MZHTTPMethod,
                    URL aUrl: NSURL,
                        httpHeaders headers: [String: String]?,
                                    httpBody bodyData: NSData?) -> NSMutableURLRequest {
        
        let mutableURLRequest = NSMutableURLRequest(URL: aUrl);
        mutableURLRequest.HTTPMethod = method.rawValue;
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField);
            }
        }
        
        mutableURLRequest.HTTPBody = bodyData;
        
        return mutableURLRequest;
    }
    
    
    
    
    //MARK: Request operation
    public func resume() {
        if startTime == nil {
            startTime = CFAbsoluteTimeGetCurrent();
        }
        
        do {
            try TaskCenter.sharedCenter.resume(self);
        } catch {
            
        }
        
    }
    
    
    public func suspend() -> Bool {
        return TaskCenter.sharedCenter.suspend(self);
    }
    
    
    
    public func cancel() -> Bool {
        return TaskCenter.sharedCenter.cancel(self);
    }
    
}


extension MZHTTPMethod {
   
    
    
}



