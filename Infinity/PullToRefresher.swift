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

public enum PullToRefreshState: Equatable, CustomStringConvertible {
    case None
    case Releasing(progress:CGFloat)
    case Loading
    
    public var description: String {
        switch self {
        case .None: return "None"
        case .Releasing(let progress): return "Releasing: \(progress)"
        case .Loading: return "Loading"
        }
    }
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
    var containerView: HeaderContainerView
    var action:(()->Void)?
    var enable = true
    
    // Values
    var defaultContentInset: UIEdgeInsets = UIEdgeInsets()
    var defaultHeightToTrigger: CGFloat = 0
    var scrollbackImmediately = true
    
    init(height: CGFloat, animator: CustomPullToRefreshAnimator) {
        self.defaultHeightToTrigger = height
        self.animator = animator
        self.containerView = HeaderContainerView()
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
                guard !updatingState && enable else {
                    return
                }
                let point = change!["new"]!.CGPointValue
                let offsetY = point.y + defaultContentInset.top
                switch offsetY {
                case 0 where state != .Loading:
                    state = .None
                case -defaultHeightToTrigger...0 where state != .Loading:
                    state = .Releasing(progress: min(-offsetY / defaultHeightToTrigger, 1.0))
                case (-CGFloat.max)...(-defaultHeightToTrigger) where state == .Releasing(progress:1):
                    if scrollView!.dragging {
                        state = .Releasing(progress: 1.0)
                    }else {
                        state = .Loading
                    }
                default:
                    break
                }
            }
            else if keyPath == "contentInset" {
                guard !self.scrollView!.lockInset else {
                    return
                }
                self.defaultContentInset = change!["new"]!.UIEdgeInsetsValue()
            }
            
        }else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    var updatingState = false
    var state: PullToRefreshState = .None {
        didSet {
            self.animator.animateState(state)
            
            switch state {
            case .None where oldValue == .Loading:
                if !self.scrollbackImmediately {
                    self.updatingState = true
                    self.scrollView?.setContentInset(self.defaultContentInset, completion: { (finished) -> Void in
                        self.updatingState = false
                    })
                }
                
            case .Loading where oldValue != .Loading:
                
                if !self.scrollbackImmediately {
                    self.updatingState = true
                    var inset = self.defaultContentInset
                    inset.top += self.defaultHeightToTrigger
                    self.scrollView?.setContentInset(inset, completion: { (finished) -> Void in
                        self.updatingState = false
                    })
                }
                self.action?()
            default:
                break
            }
        }
    }
    // MARK: - Refresh
    func beginRefreshing() {
        self.scrollView?.setContentOffset(CGPointMake(0, -(defaultHeightToTrigger + defaultContentInset.top + 1)), animated: true)
    }
    func endRefreshing() {
        self.state = .None
    }
}


class HeaderContainerView: UIView {
    
    var scrollView: UIScrollView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            view.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.firstResponderViewController()?.automaticallyAdjustsScrollViewInsets = false
    }
}

extension UIView {
    func firstResponderViewController() -> UIViewController? {
        var responder: UIResponder? = self as UIResponder
        while responder != nil {
            if responder!.isKindOfClass(UIViewController.self) {
                return responder as? UIViewController
            }
            responder = responder?.nextResponder()
        }
        return nil
    }
}

