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
    
    // Values
    var defaultContentInset: UIEdgeInsets = UIEdgeInsets()
    var defaultHeightToTrigger: CGFloat = 0
    
    init(height: CGFloat, animator: CustomPullToRefreshAnimator) {
        self.defaultHeightToTrigger = height
        self.animator = animator
        self.containerView = HeaderContainerView()
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
                guard !updatingState else {
                    return
                }
                
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
                guard !self.scrollView!.lockInset else {
                    return
                }
                self.defaultContentInset = change!["new"]!.UIEdgeInsetsValue()
            }
            
        }else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    var lockInset = false
    var updatingState = false
    var state: PullToRefreshState = .None {
        didSet {
            self.animator.animateState(state)
            
            switch state {
            case .None where oldValue == .Loading:
                self.updatingState = true
                self.scrollView?.setContentInset(self.defaultContentInset, completion: { (finished) -> Void in
                    self.updatingState = false
                })
                
            case .Loading where oldValue != .Loading:
                self.scrollView?.bounces = false
                self.updatingState = true
                
                var inset = self.defaultContentInset
                inset.top += self.defaultHeightToTrigger
                self.scrollView?.setContentInset(inset, completion: { (finished) -> Void in
                    self.updatingState = false
                    self.scrollView?.bounces = true
                })
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
        
        let firstResponderViewController = self.firstResponderViewController()
//        print(self.scrollView?.contentInset)
        print(firstResponderViewController.automaticallyAdjustsScrollViewInsets)
        
        if let navigationController = firstResponderViewController.navigationController {
            
            if firstResponderViewController.automaticallyAdjustsScrollViewInsets {
                
                if navigationController.navigationBar.hidden {
                    if let scrollView = scrollView {
                        var inset = scrollView.contentInset
                        if navigationController.prefersStatusBarHidden() {
                            inset.top = 0
                        }else {
                            inset.top = 20
                        }
                        scrollView.contentInset = inset
                        scrollView.scrollIndicatorInsets = inset
                    }
                }
                else if navigationController.navigationBar.translucent && firstResponderViewController.edgesForExtendedLayout.contains(.Top) {
                    if let scrollView = self.scrollView {
                        scrollView.contentInset = UIEdgeInsets(top: navigationController.navigationBar.frame.origin.y + navigationController.navigationBar.frame.height, left: scrollView.contentInset.left, bottom: scrollView.contentInset.bottom, right: scrollView.contentInset.right)
                        scrollView.scrollIndicatorInsets = scrollView.contentInset
                        firstResponderViewController.automaticallyAdjustsScrollViewInsets = false
                    }
                }
                firstResponderViewController.automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
}

extension UIView {
    func firstResponderViewController() -> UIViewController {
        var responder = self as UIResponder
        while responder.isKindOfClass(UIView.self) {
            responder = responder.nextResponder()!
        }
        return responder as! UIViewController
    }
}

