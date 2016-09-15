//
//  UIImageExtensions.swift
//  MZArch
//
//  Created by Jamin on 6/11/16.
//  Copyright © 2016 mz. All rights reserved.
//

import UIKit

public extension UIImage {

    public class func image(color aColor: UIColor?) -> UIImage {
        guard let targetColor: UIColor = aColor else {
            return UIImage();
        }
        
        let rect = CGRect(x: 0, y: 0, width: 4, height: 4);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, targetColor.CGColor);
        CGContextFillRect(context, rect);
        
        return UIGraphicsGetImageFromCurrentImageContext();
    }
    
}
