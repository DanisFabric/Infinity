//
//  UIScrollView+Infinity.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

private var associatedPullToRefresherKey: String  = "InfinityPullToRefresherKey"
private var associatedInfiniteScrollerKey: String = "InfinityInfiniteScrollerKey"

private var associatedEnablePullToRefreshKey: String = "InfinityEnablePullToRefreshKey"
private var associatedEnableInfiniteScrollKey: String = "InfinityEnableInfiniteScrollKey"

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
    public var enablePullToRefresh: Bool? {
        get {
            return pullToRefresher?.enable
        }
        set {
            if let newValue = newValue {
                pullToRefresher?.enable = newValue
            }
        }
    }
    public var scrollToTopImmediately: Bool? {
        get {
            return pullToRefresher?.scrollbackImmediately
        }
        set {
            if let newValue = newValue {
                pullToRefresher?.scrollbackImmediately = newValue
            }
        }
    }
}

// MARK: - InfiniteScroll
extension UIScrollView {
    
    public func addInfiniteScroll(height: CGFloat = 80.0, animator: CustomInfiniteScrollAnimator, action: (() -> Void)?) {
        
        bindInfiniteScroll(height, toAnimator: animator, action: action)
        
        if let animatorView = animator as? UIView {
            self.infiniteScroller?.containerView.addSubview(animatorView)
        }
    }
    public func bindInfiniteScroll(height: CGFloat = 80.0, toAnimator: CustomInfiniteScrollAnimator, action: (() -> Void)?) {
        removeInfiniteScroll()
        
        self.infiniteScroller = InfiniteScroller(height: height, animator: toAnimator)
        self.infiniteScroller?.scrollView = self
        self.infiniteScroller?.action = action
    }
    public func removeInfiniteScroll() {
        self.infiniteScroller?.scrollView = nil
        self.infiniteScroller = nil
    }
    public func beginInfiniteScrolling() {
        self.infiniteScroller?.beginInfiniteScrolling()
    }
    public func endInfiniteScrolling() {
        self.infiniteScroller?.endInfiniteScrolling()
    }
    
    //MARK: - Properties
    var infiniteScroller: InfiniteScroller? {
        get {
            return objc_getAssociatedObject(self, &associatedInfiniteScrollerKey) as? InfiniteScroller
        }
        set {
            objc_setAssociatedObject(self, &associatedInfiniteScrollerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 当并未添加infinityScroll时返回的为nil，表示并不支持这种配置
    public var infiniteStickToContent: Bool? {
        get {
            return self.infiniteScroller?.stickToContent
        }
        set {
            if let newValue = newValue {
                self.infiniteScroller?.stickToContent = newValue
            }
        }
    }
    public var enableInfiniteScroll: Bool? {
        get {
            return infiniteScroller?.enable
        }
        set {
            if let newValue = newValue {
                infiniteScroller?.enable = newValue
            }
        }
    }
}

private let NavigationBarHeight: CGFloat = 64
private let StatusBarHeight: CGFloat = 20
private let TabBarHeight: CGFloat = 49

public enum InfinityInsetTopType {
    case None
    case NavigationBar
    case StatusBar
    case Custom(height: CGFloat)
}
public enum InfinityInsetBottomType {
    case None
    case TabBar
    case Custom(height: CGFloat)
}

extension UIScrollView {
    public func setInsetType(withTop top: InfinityInsetTopType, bottom: InfinityInsetBottomType) {
        var insetTop: CGFloat = 0
        var insetBottom: CGFloat = 0
        
        switch top {
        case .None:
            break
        case .StatusBar:
            insetTop = StatusBarHeight
        case .NavigationBar:
            insetTop = NavigationBarHeight
        case .Custom(let height):
            insetTop = height
        }
        switch bottom {
        case .None:
            break
        case .TabBar:
            insetBottom = TabBarHeight
        case .Custom(let height):
            insetBottom = height
        }
        self.contentInset = UIEdgeInsets(top: insetTop, left: 0, bottom: insetBottom, right: 0)
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