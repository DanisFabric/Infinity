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

private var associatedisPullToRefreshEnabledKey: String = "InfinityisPullToRefreshEnabledKey"
private var associatedisInfiniteScrollEnabledKey: String = "InfinityisInfiniteScrollEnabledKey"

private var associatedInfinityKey = "Infinity.Associated.Infinity"

// MARK: - PullToRefresh
extension UIScrollView {
    public var fty: Infinity {
        get {
            if let value =  objc_getAssociatedObject(self, &associatedInfinityKey) as? Infinity {
                return value
            } else {
                let newValue = Infinity(scrollView: self)
                objc_setAssociatedObject(self, &associatedInfinityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return newValue
            }
        }
    }

}

public class PullToRefreshWrapper {
    let scrollView: UIScrollView
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    public func add(height: CGFloat = 60, animator: CustomPullToRefreshAnimator, action: (() -> Void)?) {
        scrollView.addPullToRefresh(height, animator: animator, action: action)
    }
    public func bind(height: CGFloat = 60, animator: CustomPullToRefreshAnimator, action: (() -> Void)?) {
        scrollView.bindPullToRefresh(height, toAnimator: animator, action: action)
    }
    public func remove() {
        scrollView.removePullToRefresh()
    }
    public func begin() {
        scrollView.beginRefreshing()
    }
    public func end() {
        scrollView.endRefreshing()
    }
    public var isEnabled: Bool {
        get {
            return scrollView.isPullToRefreshEnabled
        }
        set {
            scrollView.isPullToRefreshEnabled = newValue
        }
    }
    public var isScrollingToTopImmediately: Bool {
        get {
            return scrollView.isScrollingToTopImmediately
        }
        set {
            scrollView.isScrollingToTopImmediately = newValue
        }
    }
    public var animatorOffset: UIOffset {
        get {
            if let offset = scrollView.pullToRefresher?.animatorOffset {
                return offset
            }
            return UIOffset()
        }
        set {
            scrollView.pullToRefresher?.animatorOffset = newValue
        }
    }
}
public class InfiniteScrollWrapper {
    let scrollView: UIScrollView
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    public func add(height: CGFloat = 60, animator: CustomInfiniteScrollAnimator, action: (() -> Void)?) {
        scrollView.addInfiniteScroll(height, animator: animator, action: action)
    }
    public func bind(height: CGFloat = 60, animator: CustomInfiniteScrollAnimator, action: (() -> Void)?) {
        scrollView.bindInfiniteScroll(height, toAnimator: animator, action: action)
    }
    public func remove() {
        scrollView.removeInfiniteScroll()
    }
    public func begin() {
        scrollView.beginInfiniteScrolling()
    }
    public func end() {
        scrollView.endInfiniteScrolling()
    }
    public var isEnabled: Bool {
        get {
            return scrollView.isInfiniteScrollEnabled
        }
        set {
            scrollView.isInfiniteScrollEnabled = newValue
        }
    }
    public var isStickToContent: Bool {
        get {
            return scrollView.isInfiniteStickToContent
        }
        set {
            scrollView.isInfiniteStickToContent = newValue
        }
    }
}

public class Infinity {
    /// Will output some debug information if `true`.
    /// Default value: `false`
    public static var debugModeEnabled = false
    public let pullToRefresh: PullToRefreshWrapper
    public let infiniteScroll: InfiniteScrollWrapper
    
    let scrollView: UIScrollView
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        pullToRefresh = PullToRefreshWrapper(scrollView: scrollView)
        infiniteScroll = InfiniteScrollWrapper(scrollView: scrollView)
    }
    
    
    public func clear() {
        pullToRefresh.remove()
        infiniteScroll.remove()
    }
}


extension UIScrollView {
    
    func addPullToRefresh(_ height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator, action:(()->Void)?) {
        
        bindPullToRefresh(height, toAnimator: animator, action: action)
        self.pullToRefresher?.scrollbackImmediately = false
        
        if let animatorView = animator as? UIView {
            self.pullToRefresher?.containerView.addSubview(animatorView)
        }
        
    }
    func bindPullToRefresh(_ height: CGFloat = 60.0, toAnimator: CustomPullToRefreshAnimator, action:(()->Void)?) {
        removePullToRefresh()
        
        self.pullToRefresher = PullToRefresher(height: height, animator: toAnimator)
        self.pullToRefresher?.scrollView = self
        self.pullToRefresher?.action = action
    }
    func removePullToRefresh() {
        self.pullToRefresher?.scrollView = nil
        self.pullToRefresher = nil
    }
    func beginRefreshing() {
        self.pullToRefresher?.beginRefreshing()
    }
    func endRefreshing() {
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
    var isPullToRefreshEnabled: Bool {
        get {
            return pullToRefresher?.enable ?? false
        }
        set {
            pullToRefresher?.enable = newValue
        }
    }
    var isScrollingToTopImmediately: Bool {
        get {
            return pullToRefresher?.scrollbackImmediately ?? false
        }
        set {
            pullToRefresher?.scrollbackImmediately = newValue
        }
    }
}

// MARK: - InfiniteScroll
extension UIScrollView {
    
    func addInfiniteScroll(_ height: CGFloat = 80.0, animator: CustomInfiniteScrollAnimator, action: (() -> Void)?) {
        bindInfiniteScroll(height, toAnimator: animator, action: action)
        
        if let animatorView = animator as? UIView {
            self.infiniteScroller?.containerView.addSubview(animatorView)
        }
    }
    func bindInfiniteScroll(_ height: CGFloat = 80.0, toAnimator: CustomInfiniteScrollAnimator, action: (() -> Void)?) {
        removeInfiniteScroll()
        
        self.infiniteScroller = InfiniteScroller(height: height, animator: toAnimator)
        self.infiniteScroller?.scrollView = self
        self.infiniteScroller?.action = action
    }
    func removeInfiniteScroll() {
        self.infiniteScroller?.scrollView = nil
        self.infiniteScroller = nil
    }
    func beginInfiniteScrolling() {
        self.infiniteScroller?.beginInfiniteScrolling()
    }
    func endInfiniteScrolling() {
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
    var isInfiniteStickToContent: Bool {
        get {
            return self.infiniteScroller?.stickToContent ?? false
        }
        set {
            self.infiniteScroller?.stickToContent = newValue
        }
    }
    var isInfiniteScrollEnabled: Bool {
        get {
            return infiniteScroller?.enable ?? false
        }
        set {
            infiniteScroller?.enable = newValue
        }
    }
}

private var associatedSupportSpringBouncesKey:String = "InfinitySupportSpringBouncesKey"
private var associatedLockInsetKey: String           = "InfinityLockInsetKey"

extension UIScrollView {
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
    func setContentInset(_ inset: UIEdgeInsets, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            
            self.lockInset = true
            self.contentInset = inset
            self.lockInset = false
            
        }, completion: { (finished) -> Void in
            
            completion?(finished)
        })
    }
}
