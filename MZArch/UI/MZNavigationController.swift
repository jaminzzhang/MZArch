//
//  MZNavigationController.swift
//  MZArch
//
//  Created by Jamin on 6/26/16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

public class MZNavBar: UINavigationBar {
    public override var barPosition: UIBarPosition {
        return .TopAttached;
    }
    
    public override var tintColor: UIColor! {
        didSet {
            
            var navBarTextAttrs = self.titleTextAttributes;
            if navBarTextAttrs == nil {
                navBarTextAttrs = [:];
            }
            navBarTextAttrs![NSForegroundColorAttributeName] = tintColor;
            self.titleTextAttributes = navBarTextAttrs;
        }
    }
}


@objc public protocol MZNavSubViewController {

    @objc optional var shouldHideNavBar: Bool {get};
    
    /**
     The nav bar tint color of the sub view controller is different from nav bar default tint color should implement this func
     */
    @objc optional var navBarTintColor: UIColor {get};
    
    
    /**
     The navigation tint color of the sub view controller is different from navigation default tint color should implement this func
     */
    @objc optional var navTintColor: UIColor {get};
    
    
    ///
    @objc optional var supportPopGesture: Bool {get};
    
    
}


@objc public class MZNavigationController: UINavigationController, UINavigationControllerDelegate, UINavigationBarDelegate, UIGestureRecognizerDelegate {

    weak var originalDelegate: UINavigationControllerDelegate?
    var lastPopVC: UIViewController?;
    var lastOperation: UINavigationControllerOperation = .None;
    var originalNavBarFrame: CGRect = CGRectZero;
    
    
    public override weak var delegate: UINavigationControllerDelegate? {
        didSet {
            if self.delegate !== self {
                self.originalDelegate = self.delegate;
            }
            super.delegate = self;
        }
    }
    
    
    var popGestureEnable = true;
    public var supportPopGesture: Bool {
        
        get {
            
            if self.viewControllers.count <= 1 {
                return false;
            }
            
            if let mzVC = self.topViewController as? MZNavigationController {
                return mzVC.supportPopGesture;
            }
            
            return popGestureEnable;
        }
        
        set {
            popGestureEnable = newValue;
            self.updatePopGestureSupport();
        }
        
    }
    
    public var tintColor: UIColor! {
        didSet {
            self.navigationBar.tintColor = self.tintColor;
            var navBarTextAttrs = self.navigationBar.titleTextAttributes;
            if navBarTextAttrs == nil {
                navBarTextAttrs = [:];
            }
            navBarTextAttrs![NSForegroundColorAttributeName] = tintColor;
            self.navigationBar.titleTextAttributes = navBarTextAttrs;
        }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        
        self.delegate = self;
        self.originalNavBarFrame = self.navigationBar.frame;
        self.updateNavBar(false);
        
    }
    
    
    //Mark: - Gesture
    func updatePopGestureSupport() {
        
        self.interactivePopGestureRecognizer?.delegate = self;
        guard let state = self.interactivePopGestureRecognizer?.state else {
            return;
        }
        
        if ( state != .Began && state != .Changed) {
            self.interactivePopGestureRecognizer?.enabled = self.supportPopGesture;
        }
    }
    
    //MARK: - Override
    
    public override func pushViewController(viewController: UIViewController, animated: Bool) {
        self.lastOperation = .Push;
        super.pushViewController(viewController, animated: animated)
        self.updateNavBarHidden(animated, ofVC: viewController)
    }
   
    
    public override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        self.lastOperation = .Pop;
        let popVC = super.popViewControllerAnimated(animated);
        self.lastPopVC = popVC;
        self.updateNavBarHidden(animated)
        return popVC;
    }
    
    
    public override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        self.lastOperation = .Pop;
        let popVCs = super.popToViewController(viewController, animated: animated);
        self.lastPopVC = popVCs?.last;
        self.updateNavBarHidden(animated)
        
        return popVCs;
    }
    
    
    public override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        self.lastOperation = .Pop;
        let popVCs = super.popToRootViewControllerAnimated(animated);
        self.lastPopVC = popVCs?.last;
        self.updateNavBarHidden(animated)

        return popVCs;
    }
   
    
    public override func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        self.lastOperation = .None;
        super.setViewControllers(viewControllers, animated: animated);
        self.updateNavBarHidden(animated, ofVC: viewControllers.last);
    }
   
    
    
    func updateNavBarHidden(animated: Bool, ofVC: UIViewController? = nil) {
        
        var topVC: UIViewController? = nil;
        if ofVC == nil {
            topVC = self.topViewController;
        } else {
            topVC = ofVC;
        }
        
        guard let mzVC = topVC as? MZNavSubViewController else {
            return;
        }
        
        if let hideNavBar = mzVC.shouldHideNavBar {
            if hideNavBar != self.navigationBarHidden {
                self.setNavigationBarHidden(hideNavBar, animated: animated)
            }
            
        }
        
    }
    
    
    func updateNavBar(animated: Bool) {
        
        guard let mzVC = self.topViewController as? MZNavSubViewController else {
            return;
        }
//        
//        if let hideNavBar = mzVC.shouldHideNavBar {
//            
//            
//            if hideNavBar != self.navigationBarHidden {
//                self.setNavigationBarHidden(hideNavBar, animated: animated)
//            }
//            
//        }
        
        
        func updateFunc() {
            
            let originalNavBar = self.navigationBar;
            
            if let barTintColor = mzVC.navBarTintColor {
                if !barTintColor.isEqual(self.navigationBar.barTintColor) {
                    originalNavBar.barTintColor = barTintColor;
                    originalNavBar.setBackgroundImage(UIImage.image(color: barTintColor), forBarMetrics: .Default);
                }
//                originalNavBar.setBackgroundI mage(nil, forBarMetrics: .Default)
                originalNavBar.translucent = (UIColor.clearColor().isEqual(barTintColor));
            }
            
//            
//            if UIColor.clearColor().isEqual(originalNavBar.barTintColor) {
//                originalNavBar.setBackgroundImage(UIImage(), forBarMetrics: .Default);
//            }
            
            originalNavBar.shadowImage = UIImage();
            
            
            if let tintColor = mzVC.navTintColor {
                
                if !tintColor.isEqual(self.tintColor) {
                    self.tintColor = tintColor;
                }
            }
            
            self.updatePopGestureSupport();

        }
       
        if animated {
            
            UIView.animateWithDuration(NSTimeInterval(UINavigationControllerHideShowBarDuration), delay: 0, options: .BeginFromCurrentState, animations: {
                updateFunc();
                
            }) { (finished: Bool) in
                if (finished) {
//                updateFunc();
                }
            }
        } else {
            updateFunc();
        }
    
        
    }
    
    
    func clearNavBar() {
        
        let count = self.viewControllers.count;
        let left = count >= 2 ? count-2 : count - 1;
        for i in left ..< count  {
            for view in self.viewControllers[i].view.subviews {
                if view is UINavigationBar {
                    view.removeFromSuperview();
                }
            }
        }
        
    }
   
    //MARK: - UINavigationControllerDelegate
    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        guard let mzVC = viewController as? MZNavSubViewController else {
            return;
        }
        
        guard let barTintColor = mzVC.navBarTintColor else {
            return;
        }
        
        if barTintColor.isEqual(UIColor.clearColor()) {
            return;
        }
    
        if barTintColor.isEqual(navigationController.navigationBar.barTintColor) {
            return;
        }
        
 
        let currBarTintColorClear = UIColor.clearColor().isEqual(navigationController.navigationBar.barTintColor);
        navigationController.navigationBar.translucent = true;//(UIColor.clearColor().isEqual(barTintColor));
//        navigationController.navigationBar.barTintColor = barTintColor;
        
        var shouldFakeCurrNavBar = false;
        if let hidden = mzVC.shouldHideNavBar {
            shouldFakeCurrNavBar = !hidden;
        }
        
        if shouldFakeCurrNavBar {
            
            //fake a nav bar
            let fakeNavBar = self.buildNavBar(barTintColor);
            viewController.view.addSubview(fakeNavBar);
//            let frame = navigationController.view.convertRect(self.originalNavBarFrame, toView: viewController.view)
//            fakeNavBar.frame = frame;
            
            if !currBarTintColorClear {
                navigationController.navigationBar.setBackgroundImage(UIImage.image(color: barTintColor), forBarMetrics: .Default)
            }
           
        }
        
        
        //fake navigatinBar of preview vc
        var preVC: UIViewController? = nil;
        if self.lastOperation == .Pop {
            preVC = self.lastPopVC;
        } else {
            let navVCCount = navigationController.viewControllers.count;
            if navVCCount >= 2 {
                preVC = navigationController.viewControllers[navVCCount - 2];
            }
        }
        
        var shouldFakePrevNavBar = preVC?.edgesForExtendedLayout != .None;
        if let preMZVc = preVC as? MZNavSubViewController {
            if let prevHidden = preMZVc.shouldHideNavBar {
                shouldFakePrevNavBar = !prevHidden;
            } else {
                shouldFakePrevNavBar = !currBarTintColorClear;
            }
        }
        
        if shouldFakePrevNavBar {
            let preNavBar = self.buildNavBar(self.navigationBar.barTintColor);
            preVC?.view.addSubview(preNavBar);
//            let frame = navigationController.view.convertRect(self.originalNavBarFrame, toView: viewController.view)
//            preNavBar.frame = frame;
            
        }
        
        
//        if shouldFakeCurrNavBar || shouldFakePrevNavBar {
//            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default);
//        }
//        

        
//        self.updateNavBar(animated)
        
    }
    
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
       
        
        if !self.navigationBarHidden {
            self.originalNavBarFrame = self.navigationBar.frame;
        }
        
        if let mzNavController = navigationController as? MZNavigationController {
            mzNavController.clearNavBar();
            mzNavController.updateNavBarHidden(false);
            mzNavController.updateNavBar(false);
        }
    }
    
    
    
    
    //MARK: - 
    func buildNavBar(barTintColor: UIColor?) -> UINavigationBar {
        let originalNavBar = self.navigationBar;
        let fakeNavBar = MZNavBar();
        fakeNavBar.barStyle = originalNavBar.barStyle;
        fakeNavBar.setBackgroundImage(UIImage.image(color: barTintColor), forBarMetrics: .Default);
        fakeNavBar.translucent = (UIColor.clearColor().isEqual(barTintColor));
//        fakeNavBar.barTintColor = barTintColor;
        var frame = self.originalNavBarFrame;
        frame.origin.y = -frame.size.height;
        fakeNavBar.frame = frame;
        fakeNavBar.delegate = self;
        fakeNavBar.shadowImage = originalNavBar.shadowImage;
        
        if UIColor.clearColor().isEqual(barTintColor) {
            fakeNavBar.setBackgroundImage(UIImage(), forBarMetrics: .Default);
        }
        
        return fakeNavBar;
    }
    
    
    
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached;
    }
    

}
