//
//  PullToRefresher.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public protocol CustomPullToRefreshAnimator {
    func animateState(_ state: PullToRefreshState)
}

public enum PullToRefreshState: Equatable, CustomStringConvertible {
    case none
    case releasing(progress:CGFloat)
    case loading
    
    public var description: String {
        switch self {
        case .none: return "None"
        case .releasing(let progress): return "Releasing: \(progress)"
        case .loading: return "Loading"
        }
    }
}
public func == (left: PullToRefreshState, right: PullToRefreshState) -> Bool {
    switch (left, right) {
    case (.none, .none): return true
    case (.releasing, .releasing): return true
    case (.loading, .loading): return true
    default:
        return false
    }
}

class PullToRefresher: NSObject {
    func containerFrame(scrollView: UIScrollView) -> CGRect{
            let horizontalFrame = CGRect(x: -defaultDistanceToTrigger + animatorOffset.horizontal, y: animatorOffset.vertical, width: defaultDistanceToTrigger, height: scrollView.frame.height)
            let verticalFrame = CGRect(x: 0 + animatorOffset.horizontal, y: -defaultDistanceToTrigger + animatorOffset.vertical, width: scrollView.frame.width, height: defaultDistanceToTrigger)
            return direction == .horizontal ? horizontalFrame : verticalFrame
    }

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
                containerView.frame = containerFrame(scrollView: scrollView)
            }
        }
    }
    var animator: CustomPullToRefreshAnimator
    var containerView: HeaderContainerView
    var direction: InfinityScrollDirection
    var action:(()->Void)?
    var enable = true
    
    var animatorOffset: UIOffset = UIOffset() {
        didSet {
            if let scrollView = scrollView {
                containerView.frame = containerFrame(scrollView: scrollView)
            }
        }
    }
    // Values
    var defaultContentInset: UIEdgeInsets = UIEdgeInsets()
    var defaultDistanceToTrigger: CGFloat = 0
    var scrollbackImmediately = true
    
    init(height: CGFloat, direction: InfinityScrollDirection, animator: CustomPullToRefreshAnimator) {
        self.defaultDistanceToTrigger = height
        self.animator = animator
        self.containerView = HeaderContainerView()
        self.direction = direction
        
    }
    // MARK: - Observe Scroll View
    var KVOContext = "PullToRefreshKVOContext"
    func addScrollViewObserving(_ scrollView: UIScrollView?) {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: "contentInset", options: .new, context: &KVOContext)
        
    }
    func removeScrollViewObserving(_ scrollView: UIScrollView?) {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentInset", context: &KVOContext)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContext {
            if keyPath == "contentOffset" {
                guard !updatingState && enable else {
                    return
                }
                let point = (change![.newKey]! as AnyObject).cgPointValue!
                let topOffset = direction == .horizontal ? point.x + defaultContentInset.left : point.y + defaultContentInset.top                
                switch topOffset {
                case 0 where state != .loading:
                    state = .none
                case -defaultDistanceToTrigger...0 where state != .loading:
                    state = .releasing(progress: min(-topOffset / defaultDistanceToTrigger, 1.0))
                case (-CGFloat.greatestFiniteMagnitude)...(-defaultDistanceToTrigger) where state == .releasing(progress:1):
                    if scrollView!.isDragging {
                        state = .releasing(progress: 1.0)
                    }else {
                        state = .loading
                    }
                default:
                    break
                }
            }
            else if keyPath == "contentInset" {
                guard !self.scrollView!.lockInset else {
                    return
                }
                self.defaultContentInset = (change![.newKey]! as AnyObject).uiEdgeInsetsValue!
            }
            
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    var updatingState = false
    var state: PullToRefreshState = .none {
        didSet {
            self.animator.animateState(state)
            print("Scrollview refresher state: \(state)")
            print("Scrollview refresher old state: \(oldValue)")
            print("Scroll Enabled: \(self.scrollView?.isScrollEnabled)")
            DispatchQueue.main.async {
                switch self.state {
                case .none where oldValue == .loading:
                    if !self.scrollbackImmediately {
                        self.updatingState = true
                        if self.scrollView is UICollectionView {
                            self.scrollView?.setContentInset(self.defaultContentInset, completion: { [unowned self] (finished) -> Void in
                                self.updatingState = false
                            })
                        } else {
                            print("Restoring default content inset: \(self.defaultContentInset)")
                            
                            self.scrollView?.setContentInset(self.defaultContentInset, completion: { [unowned self] (finished) -> Void in
                                self.updatingState = false
                            })
                        }
                    }
                    
                case .loading where oldValue != .loading:
                        if !self.scrollbackImmediately {
                            self.updatingState = true
                            var inset = self.defaultContentInset
                            if self.direction == .horizontal{
                                inset.left += self.defaultDistanceToTrigger
                            }
                            else{
                                inset.top += self.defaultDistanceToTrigger
                            }
                            self.scrollView?.setContentInset(inset, completion: { [unowned self] (finished) -> Void in
                                self.updatingState = false
                            })
                            self.action?()
                        }
                default:
                    break
                }
            }
        }
    }
    // MARK: - Refresh
    func beginRefreshing() {
        let horizontalContentOffset = CGPoint(x: 0, y: -(defaultDistanceToTrigger + defaultContentInset.top + 1))
        let verticalContentOffset = CGPoint(x: -(defaultDistanceToTrigger + defaultContentInset.left + 1), y: 0)
        self.scrollView?.setContentOffset(direction == .horizontal ? horizontalContentOffset : verticalContentOffset , animated: true)
    }
    func endRefreshing() {
        self.state = .none
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
            if responder!.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            responder = responder?.next
        }
        return nil
    }
}

