//
//  UIViewSeperatorExtensions.swift
//  MZArch
//
//  Created by Jamin on 6/23/16.
//  Copyright © 2016 mz. All rights reserved.
//

import UIKit

public struct ViewEdge : OptionSetType  {
    public let rawValue: UInt;
    public init(rawValue: UInt) {
        self.rawValue = rawValue;
    }
    
    public static let None = ViewEdge(rawValue: 0)
    public static let Top = ViewEdge(rawValue: 1 << 0)
    public static let Left = ViewEdge(rawValue: 1 << 1)
    public static let Bottom = ViewEdge(rawValue: 1 << 2)
    public static let Right = ViewEdge(rawValue: 1 << 3)
    
}


public extension OptionSetType where Element == Self, RawValue : UnsignedIntegerType {
    func elements() -> AnySequence<Self> {
        var rawValue = Self.RawValue(1)
        return AnySequence( {
            return AnyGenerator(body: {
                while rawValue != 0 {
                    let candidate = Self(rawValue: rawValue)
                    rawValue = rawValue &* 2
                    if self.contains(candidate) {
                        return candidate
                    }
                }
                
                return nil
            })
        })
    }
}

public class SeperatorView: UIView {
    
    public let seperatorLineSize = 1.0/UIScreen.mainScreen().scale;
    public let edge: ViewEdge;
    public var edgeInset: UIEdgeInsets = UIEdgeInsetsZero;
    
    init(edge: ViewEdge) {
        self.edge = edge;
        super.init(frame: CGRectMake(0, 0, seperatorLineSize, seperatorLineSize));
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override public func willMoveToSuperview(newSuperview: UIView?) {
        guard let aSuperview = newSuperview else {
            return;
        }
        
        switch edge {
        case ViewEdge.Top:
            self.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
            self.frame = CGRect(x: edgeInset.left,
                                y: edgeInset.top,
                                width: aSuperview.width - edgeInset.left - edgeInset.right,
                                height: self.seperatorLineSize);
            
        case ViewEdge.Left:
            self.autoresizingMask = [.FlexibleRightMargin, .FlexibleHeight]
            self.frame = CGRect(x: edgeInset.left,
                                y: edgeInset.top,
                                width: self.seperatorLineSize,
                                height: aSuperview.height - edgeInset.top - edgeInset.bottom);
            
            
        case ViewEdge.Bottom:
            self.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
            self.frame = CGRect(x: edgeInset.left,
                                y: aSuperview.height - edgeInset.bottom - self.seperatorLineSize,
                                width: aSuperview.width - edgeInset.left - edgeInset.right,
                                height: self.seperatorLineSize);
            
        case ViewEdge.Right:
            self.autoresizingMask = [.FlexibleLeftMargin,  .FlexibleHeight];
            self.frame = CGRect(x: aSuperview.width - edgeInset.right - self.seperatorLineSize,
                                y: edgeInset.top,
                                width: self.seperatorLineSize,
                                height: aSuperview.height - edgeInset.top - edgeInset.bottom);
            
        default: break
            
        }
    }
}




public extension UIView {


    public func addSeperator(edge: ViewEdge,
                             color: UIColor = UIColor(hexRGB: 0xc8c7cc),
                             edgeInsets: UIEdgeInsets = UIEdgeInsetsZero,
                             isExclusive: Bool = true) -> [SeperatorView] {
       
       var result: [SeperatorView] = [];
        for aEdge in edge.elements() {
            if isExclusive {
                if let sepViews = self.seperatorViews(aEdge) {
                    result += sepViews;
                    continue;
                }
            }
            
            let sepView = SeperatorView(edge: edge);
            sepView.backgroundColor = color;
            sepView.edgeInset = edgeInsets;
            self.addSubview(sepView);
            
            result.append(sepView);
        }
        
        return result;
    }
    
    
    
    public func seperatorViews(edge: ViewEdge = ViewEdge.None) -> [SeperatorView]? {
//        return self.subviews.filter{$0 is SeperatorView} as? [SeperatorView];
        var result: [SeperatorView] = [];
        for subview in self.subviews {
            if let sepView = subview as? SeperatorView {
                if edge.contains(sepView.edge) {
                    result.append(sepView);
                }
            }
        }
        
        if result.isEmpty {
            return nil;
        }
        
        return result;
    }
    
    
    
}
