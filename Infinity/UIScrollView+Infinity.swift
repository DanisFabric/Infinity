//
//  UIScrollView+Infinity.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

private var associatedPullToRefresherKey:String  = "InfinityPullToRefresherKey"
private var associatedInfinityScrollerKey:String = "InfinityInfinityScrollerKey"

// MARK: - PullToRefresh
extension UIScrollView {

    public func addPullToRefresh(height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator, action:(()->Void)?) {
        
        bindPullToRefresh(height, toAnimator: animator, action: action)
        self.pullToRefresher?.scrollbackImmediately = false
        
        if let animatorView = animator as? UIView {
            self.pullToRefresher?.containerView.addSubview(animatorView)
        }
        
    }
    public func bindPullToRefresh(height: CGFloat = 60.0, toAnimator: CustomPullToRefreshAnimator, action:(()->Void)?) {
        removePullToRefresh()
        
        self.pullToRefresher = PullToRefresher(height: height, animator: toAnimator)
        self.pullToRefresher?.scrollView = self
        self.pullToRefresher?.action = action
    }
    public func removePullToRefresh() {
        self.pullToRefresher?.scrollView = nil
        self.pullToRefresher = nil
    }
    public func beginRefreshing() {
        self.pullToRefresher?.beginRefreshing()
    }
    public func endRefreshing() {
        self.pullToRefresher?.endRefreshing()
    }
    
    //MARK: - Properties
    var pullToRefresher: PullToRefresher? {
        get {
            return objc_getAssociatedObject(self, &associatedPullToRefresherKey) as? PullToRefresher
        }
        set {
            objc_setAssociatedObject(self, &associatedPullToRefresherKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 当并未addPullToRefresh的时候，返回值为nil，表示并不支持这种配置
    public var pullToRefreshScrollbackImmediately: Bool? {
        get {
            return self.pullToRefresher?.scrollbackImmediately
        }
        set {
            if let newValue = newValue {
                self.pullToRefresher?.scrollbackImmediately = newValue
            }
        }
    }
}

// MARK: - InfinityScroll
extension UIScrollView {
    
    public func addInfinityScroll(height: CGFloat = 80.0, animator: CustomInfinityScrollAnimator, action: (() -> Void)?) {
        
        bindInfinityScroll(height, toAnimator: animator, action: action)
        
        if let animatorView = animator as? UIView {
            self.infinityScroller?.containerView.addSubview(animatorView)
        }
    }
    public func bindInfinityScroll(height: CGFloat = 80.0, toAnimator: CustomInfinityScrollAnimator, action: (() -> Void)?) {
        removeInfinityScroll()
        
        self.infinityScroller = InfinityScroller(height: height, animator: toAnimator)
        self.infinityScroller?.scrollView = self
        self.infinityScroller?.action = action
    }
    public func removeInfinityScroll() {
        self.infinityScroller?.scrollView = nil
        self.infinityScroller = nil
    }
    public func beginInfinityScrolling() {
        self.infinityScroller?.beginInfinityScrolling()
    }
    public func endInfinityScrolling() {
        self.infinityScroller?.endInfinityScrolling()
    }
    
    //MARK: - Properties
    var infinityScroller: InfinityScroller? {
        get {
            return objc_getAssociatedObject(self, &associatedInfinityScrollerKey) as? InfinityScroller
        }
        set {
            objc_setAssociatedObject(self, &associatedInfinityScrollerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 当并未添加infinityScroll时返回的为nil，表示并不支持这种配置
    public var infinityStickToContent: Bool? {
        get {
            return self.infinityScroller?.stickToContent
        }
        set {
            if let newValue = newValue {
                self.infinityScroller?.stickToContent = newValue
            }
        }
    }
}


private var associatedSupportSpringBouncesKey:String = "InfinitySupportSpringBouncesKey"
private var associatedLockInsetKey: String           = "InfinityLockInsetKey"


extension UIScrollView {
    public var supportSpringBounces: Bool {
        get {
             let support = objc_getAssociatedObject(self, &associatedSupportSpringBouncesKey) as? Bool
            if support == nil {
                return false
            }
            return support!
        }
        set {
            objc_setAssociatedObject(self, &associatedSupportSpringBouncesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var lockInset: Bool {
        get {
            let locked = objc_getAssociatedObject(self, &associatedLockInsetKey) as? Bool
            if locked == nil {
                return false
            }
            return locked!
        }
        set {
            objc_setAssociatedObject(self, &associatedLockInsetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setContentInset(inset: UIEdgeInsets, completion: ((Bool) -> Void)?) {
        if self.supportSpringBounces {
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [.CurveEaseInOut,.AllowUserInteraction,.BeginFromCurrentState], animations: { () -> Void in
                
                self.lockInset = true
                self.contentInset = inset
                self.lockInset = false
                
                }, completion: completion)
            
        }else {
            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseInOut,.AllowUserInteraction,.BeginFromCurrentState], animations: { () -> Void in
                
                self.lockInset = true
                self.contentInset = inset
                self.lockInset = false

                }, completion: { (finished) -> Void in
                    
                    completion?(finished)
            })
        }
    }
}