/*
 * Response.swift
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


public struct Response<Value, Error: ErrorType> {
    
    public var HTTPResponse: NSHTTPURLResponse?;
    public var responseData: NSData?;
    
    public var retCode: Int = 0;
    
    public var result: Result<Value, Error>?;
    
    public init(HTTPResponse response: NSHTTPURLResponse?, responseData rspData: NSData?) {
        self.HTTPResponse = response;
        self.responseData = rspData;
    }
}


public class JSONResponse {
    
    var jsonDictionary: [String: AnyObject]?;
    
}












