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
        didSet {
            removeScrollViewObserving(oldValue)
            self.containerView.removeFromSuperview()
            
            addScrollViewObserving(scrollView)
            if let scrollView = scrollView {
                defaultContentInset = scrollView.contentInset
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
        self.containerView = HeaderFooterContainerView()
        self.containerView.backgroundColor = UIColor.redColor()
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
                print(offsetY)
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
                self.state = .None // 需要重置一下
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
                self.lockInset = true

                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.CurveEaseInOut], animations: { () -> Void in
                    
                    self.scrollView?.contentInset = self.defaultContentInset
                    
                    }, completion: { (finished) -> Void in
                        self.scrollView?.bounces = true
                        self.lockInset = false
                })
            case .Loading where oldValue != .Loading:
                self.scrollView?.bounces = false
                self.lockInset = true
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.CurveEaseInOut], animations: { () -> Void in
                    
                    var inset = self.defaultContentInset
                    inset.top += self.defaultHeightToTrigger
                    self.scrollView?.contentInset = inset
                    
                    }, completion: { (finished) -> Void in
                        self.scrollView?.bounces = true
                        self.lockInset = false
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

