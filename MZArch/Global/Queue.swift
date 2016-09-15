//
//  Queue.swift
//  MZArch
//
//  Created by Jamin on 4/26/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation

let kQueueNameKey = "QueueName";


//MARK: - Create queue with specific

public func dispatch_create_serial_queue(label: UnsafePointer<Int8>) -> dispatch_queue_t! {
    let queue = dispatch_create_specific_queue(label, DISPATCH_QUEUE_SERIAL);
    return queue;
}


public func dispatch_create_concurrent_queue(label: UnsafePointer<Int8>) -> dispatch_queue_t! {
    let queue = dispatch_create_specific_queue(label, DISPATCH_QUEUE_CONCURRENT);
    return queue;
}

public func dispatch_create_specific_queue(label: UnsafePointer<Int8>, _ attr: dispatch_queue_attr_t!) -> dispatch_queue_t! {
    let queue = dispatch_queue_create(label, attr);
    dispatch_queue_set_specific(queue, kQueueNameKey, UnsafeMutablePointer(label), nil);
    return queue;
}





//MARK: - Run block in queue
public func dispatch_current_queue_same_as(queue: dispatch_queue_t) -> Bool {
    
    if (dispatch_get_main_queue() === queue && NSThread.isMainThread()) {
        return true;
    }
    
    return (dispatch_queue_get_specific(queue, kQueueNameKey) == dispatch_get_specific(kQueueNameKey));
}



public func dispatch_sync_in_queue(queue: dispatch_queue_t, block: dispatch_block_t) {
    
    if (dispatch_current_queue_same_as(queue)) {
        block();
    } else {
        dispatch_sync(queue, block);
    }
    
}


public func dispatch_async_in_queue(queue: dispatch_queue_t, block: dispatch_block_t) {
    
    if (dispatch_current_queue_same_as(queue)) {
        block();
    } else {
        dispatch_async(queue, block);
    }
    
}



public func dispatch_barrier_sync_in_queue(queue: dispatch_queue_t, block: dispatch_block_t) {
    
    if (dispatch_current_queue_same_as(queue)) {
        block();
    } else {
        dispatch_barrier_sync(queue, block);
    }
    
}


public func dispatch_barrier_async_in_queue(queue: dispatch_queue_t, block: dispatch_block_t) {
    
    if (dispatch_current_queue_same_as(queue)) {
        block();
    } else {
        dispatch_barrier_async(queue, block);
    }
    
}


public func dispatch_sync_in_main_queue(block: dispatch_block_t) {
    if (NSThread.isMainThread()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    
}



public func dispatch_async_in_main_queue(block: dispatch_block_t) {
    if (NSThread.isMainThread()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    
}



