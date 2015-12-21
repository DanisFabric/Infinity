//
//  UIScrollView+Infinity.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

private var associatedPullToRefresherKey:UInt8 = 1
private var associatedInfinityScrollerKey:UInt8 = 2

// MARK: - PullToRefresh
extension UIScrollView {

    public func addPullToRefresh(height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator) {
        
    }
    public func bindPullToRefresh(height: CGFloat = 60.0, toAnimator: CustomPullToRefreshAnimator) {
        
    }
    public func removePullToRefresh() {
        
    }
    public func beginRefreshing() {
        
    }
    public func endRefreshing() {
        
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
}

// MARK: - InfinityScroll
extension UIScrollView {
    
    public func addInfinityScroll(height: CGFloat = 60.0, animator: CustomInfinityScrollAnimator) {
        
    }
    public func bindInfinityScroll(height: CGFloat = 60.0, toAnimator: CustomInfinityScrollAnimator) {
        
    }
    public func removeInfinityScroll() {
        
    }
    public func beginInfinityScrolling() {
        
    }
    public func endInfinityScrolling() {
        
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
}
