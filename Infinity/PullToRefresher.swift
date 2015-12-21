//
//  PullToRefresher.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public protocol CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState)
}

public enum PullToRefreshState: Equatable {
    case None
    case Releasing(progress:CGFloat)
    case Loading
}
public func == (left: PullToRefreshState, right: PullToRefreshState) -> Bool {
    switch (left, right) {
    case (.None, .None): return true
    case (.Releasing, .Releasing): return true
    case (.Loading, .Loading): return true
    default:
        return false
    }
}

class PullToRefresher: NSObject {
    weak var scrollView: UIScrollView? {
        willSet {
            removeScrollViewObserving(scrollView)
            self.containerView.removeFromSuperview()
        }
        didSet {
            addScrollViewObserving(scrollView)
            if let scrollView = scrollView {
                defaultContentInset = scrollView.contentInset
                containerView.scrollView = scrollView
                
                scrollView.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: -defaultHeightToTrigger, width: scrollView.frame.width, height: defaultHeightToTrigger)
            }
        }
    }
    var animator: CustomPullToRefreshAnimator
    var containerView: HeaderFooterContainerView
    var action:(()->Void)?
    
    // Values
    var lockInset = false
    var defaultContentInset: UIEdgeInsets = UIEdgeInsets()
    var defaultHeightToTrigger: CGFloat = 0
    
    init(height: CGFloat, animator: CustomPullToRefreshAnimator) {
        self.defaultHeightToTrigger = height
        self.animator = animator
        self.containerView = HeaderFooterContainerView(type: HeaderFooterType.Header)
        self.containerView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
    }
    // MARK: - Observe Scroll View
    var KVOContext = "PullToRefreshKVOContext"
    func addScrollViewObserving(scrollView: UIScrollView?) {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .New, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: "contentInset", options: .New, context: &KVOContext)
        
    }
    func removeScrollViewObserving(scrollView: UIScrollView?) {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentInset", context: &KVOContext)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &KVOContext {
            if keyPath == "contentOffset" {
                let point = change!["new"]!.CGPointValue
                let offsetY = point.y + defaultContentInset.top
                switch offsetY {
                case 0 where state != .Loading:
                    state = .None
                case -defaultHeightToTrigger...0 where state != .Loading:
                    state = .Releasing(progress: min(-offsetY / defaultHeightToTrigger, 1.0))
                case (-CGFloat.max)...(-defaultHeightToTrigger) where state == .Releasing(progress:1) && scrollView?.dragging == false:
                    state = .Loading
                default:
                    break
                }
            }
            else if keyPath == "contentInset" && !lockInset {
                self.defaultContentInset = change!["new"]!.UIEdgeInsetsValue()
            }
            
        }else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    var state: PullToRefreshState = .None {
        didSet {
            self.animator.animateState(state)
            
            switch state {
            case .None where oldValue == .Loading:
                self.scrollView?.bounces = false
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [.CurveEaseInOut,.AllowUserInteraction], animations: { () -> Void in
                    
                    self.lockInset = true
                    self.scrollView?.contentInset = self.defaultContentInset
                    // insets 的0和64区别在于参照物的不同，弹出新的VC之后，参照物变了，所以弹回的距离需要一个改变
                    
                    }, completion: { (finished) -> Void in
                        self.scrollView?.bounces = true
                        print(self.scrollView?.contentInset)
                })
                
            case .Loading where oldValue != .Loading:
                self.scrollView?.bounces = false
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [.CurveEaseInOut,.AllowUserInteraction,.BeginFromCurrentState], animations: { () -> Void in
                    
                    var inset = self.defaultContentInset
                    inset.top += self.defaultHeightToTrigger
                    
                    self.lockInset = true
                    self.scrollView?.contentInset = inset
                    
                    }, completion: { (finished) -> Void in
                        self.scrollView?.bounces = true
                })
                self.action?()
            default:
                break
            }
        }
    }
    
    func beginRefreshing() {
        
    }
    func endRefreshing() {
        self.state = .None
    }
}

