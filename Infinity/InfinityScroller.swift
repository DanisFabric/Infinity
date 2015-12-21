//
//  InfinityScroller.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public protocol CustomInfinityScrollAnimator {
    func animateState(state: InfinityScrollState)
}

public enum InfinityScrollState: Equatable {
    case None
    case Loading
}
public func == (left: InfinityScrollState, right: InfinityScrollState) -> Bool {
    switch (left, right) {
    case (.None, .None): return true
    case (.Loading, .Loading): return true
    default:
        return false
    }
}

class InfinityScroller: NSObject {
    weak var scrollView: UIScrollView? {
        willSet {
            removeScrollViewObserving(scrollView)
            self.containerView.removeFromSuperview()
        }
        didSet {
            addScrollViewObserving(scrollView)
            if let scrollView = scrollView {
                defaultContentInset = scrollView.contentInset
                
                scrollView.addSubview(containerView)
                adjustFooterFrame()
            }
        }
    }
    var animator: CustomInfinityScrollAnimator
    var containerView: HeaderFooterContainerView
    var action: (() -> Void)?
    
    // Values
    var defaultContentInset = UIEdgeInsets()
    var defaultHeightToTrigger: CGFloat = 0
    
    init(height: CGFloat, animator: CustomInfinityScrollAnimator) {
        self.defaultHeightToTrigger = height
        self.animator = animator
        self.containerView = HeaderFooterContainerView(type: HeaderFooterType.Footer)
        self.containerView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
    }
    
    // MARK: - Observe Scroll View
    var KVOContext = "InfinityScrollKVOContext"
    func addScrollViewObserving(scrollView: UIScrollView?) {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .New, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: "contentInset", options: .New, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: .New, context: &KVOContext)
    }
    func removeScrollViewObserving(scrollView: UIScrollView?) {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentInset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentSize", context: &KVOContext)
    }
    func adjustFooterFrame() {
//        containerView.frame = CGRect(x: 0, y: defaultHeightToTrigger, width: scrollView.frame.width, height: defaultHeightToTrigger)
    }
    // MARK: - Infinity Scroll
    func beginInfinityScrolling() {
        
    }
    func endInfinityScrolling() {
        
    }
}
