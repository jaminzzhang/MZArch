//
//  UIViewAdditions.swift
//  CCDo
//
//  Created by Jamin on 6/8/16.
//  Copyright © 2016 ColorCode. All rights reserved.
//

import UIKit

public extension UIView {

    public var x: CGFloat {
        get {
            return self.frame.origin.x;
        }
        
        set {
//            var aFrame = self.frame;
//            aFrame.origin.x = newValue;
//            self.frame = aFrame;
            self.frame.origin.x = newValue;
        }
    }
    
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y;
        }
        
        set {
            self.frame.origin.y = newValue;
        }
    }
    
    
    
    public var width: CGFloat {
        get {
            return self.frame.size.width;
        }
        
        set {
            self.frame.size.width = newValue;
        }
    }
    
    
    
    public var height: CGFloat {
        get {
            return self.frame.size.height;
        }
        
        set {
            self.frame.size.height = newValue;
        }
    }
    
    
    
    
    public var left: CGFloat {
        get {
            return self.frame.origin.x;
        }
        
        set {
            self.frame.origin.x = newValue;
        }
    }
    
    
    
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width;
        }
        
        set {
//            let oldWidth = self.frame.size.width;
            self.frame.size.width = newValue - self.frame.origin.x;
        }
    }
    
    
    
    
    public var top: CGFloat {
        get {
            return self.frame.origin.y;
        }
        
        set {
            self.frame.origin.y = newValue;
        }
    }
    
    
    
    
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
        
        set {
            //            let oldWidth = self.frame.size.width;
            self.frame.size.height = newValue - self.frame.origin.y;
        }
    }
    
    
    

}
