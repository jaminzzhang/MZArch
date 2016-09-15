//
//  UIColor.swift
//  CCDo
//
//  Created by Jamin on 4/22/16.
//  Copyright © 2016 ColorCode. All rights reserved.
//

import UIKit

public extension UIColor {
    public convenience init(hexRGB rgb: Int, alpha: CGFloat = 1) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8)/255.0,
                  blue: CGFloat(rgb & 0x0000FF)/255.0,
                  alpha: alpha);
    }
    
}