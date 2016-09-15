//
//  BaseHandler.swift
//  MZArch
//
//  Created by Jamin on 4/17/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation

public class BaseHandler {
    
    private var pHandleQueue: dispatch_queue_t?;
    public var handleQueue: dispatch_queue_t {
        get {
            if nil == pHandleQueue {
                let handlerName = String(self.dynamicType);
                pHandleQueue = dispatch_create_serial_queue(handlerName);
            }
            
            return pHandleQueue!;
        }
    }
    
    //Default is main queue
    private var pCallbackQueue: dispatch_queue_t?;
    public var callbackQueue: dispatch_queue_t {
        get {
            if nil == pCallbackQueue {
                pCallbackQueue = dispatch_get_main_queue();
            }
            
            return pCallbackQueue!;
        }
        
        set {
            pHandleQueue = newValue;
        }
    }
    
    
    public init(handleQueue hQueue: dispatch_queue_t = dispatch_create_serial_queue(String(BaseHandler.self)),
                     callbackQueue cQueue: dispatch_queue_t = dispatch_get_main_queue()) {
        pHandleQueue = hQueue;
        pCallbackQueue = cQueue;
    }
    
    
    
    
    /**
     Run a task in handleQueue
     
     - parameter taskBlock:
     */
    public func handleTask(taskBlock: dispatch_block_t) {
        dispatch_async_in_queue(self.handleQueue, block: taskBlock)
    }
    
    
    
    /**
     Run a callback in callbackQueue
     
     - parameter taskBlock:
     */
    public func callback(callbackBlock: dispatch_block_t) {
        dispatch_async_in_queue(self.callbackQueue, block: callbackBlock)
    }
    
}


