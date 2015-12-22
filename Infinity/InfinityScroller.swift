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
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &KVOContext {
            if keyPath == "contentSize" {
                adjustFooterFrame()
            }
            else if keyPath == "contentInset" {
                guard !lockInset else {
                    return
                }
                if let outLockInset = scrollView?.pullToRefresher?.lockInset {
                    guard !outLockInset else {
                        return
                    }
                }
                defaultContentInset = change!["new"]!.UIEdgeInsetsValue()
                adjustFooterFrame()
            }
            else if keyPath == "contentOffset" {
                let point = change!["new"]!.CGPointValue

                let distance = scrollView!.contentSize.height + self.defaultContentInset.bottom - point.y - scrollView!.frame.height
                // 要保证scrollView里面是有内容的
                if distance < 0 && self.state != .Loading && scrollView!.contentSize.height > 0 {
                    self.state = .Loading
                }
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    var lockInset = false
    var state: InfinityScrollState = .None {
        didSet {
            self.animator.animateState(state)
            
            switch state {
            case .Loading where oldValue == .None:
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.lockInset = true
                    self.scrollView?.contentInset = UIEdgeInsets(top: self.defaultContentInset.top, left: self.defaultContentInset.left, bottom: self.defaultHeightToTrigger + self.defaultContentInset.bottom, right: self.defaultContentInset.right)
                    self.lockInset = false
                    
                    }, completion: { (finished) -> Void in
                        
                })
                action?()
            case .None where oldValue == .Loading:
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.lockInset = true
                    self.scrollView?.contentInset = self.defaultContentInset
                    self.lockInset = false
                    }, completion: { (finished) -> Void in
                        
                })
            default:
                break
            }
        }
    }
    
    func adjustFooterFrame() {
        if let scrollView = scrollView {
            containerView.frame = CGRect(x: 0, y: scrollView.contentSize.height + self.defaultContentInset.bottom, width: scrollView.bounds.width, height: defaultHeightToTrigger)
        }
    }
    // MARK: - Infinity Scroll
    func beginInfinityScrolling() {
        scrollView?.setContentOffset(CGPoint(x: 0, y: (scrollView!.contentSize.height + defaultContentInset.bottom - scrollView!.frame.height + defaultHeightToTrigger)), animated: true)
    }
    func endInfinityScrolling() {
        self.state = .None
    }
}
