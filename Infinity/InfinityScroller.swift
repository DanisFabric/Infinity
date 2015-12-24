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

public enum InfinityScrollState: Equatable, CustomStringConvertible {
    case None
    case Loading
    
    public var description: String {
        switch self {
        case .None: return "None"
        case .Loading: return "Loading"
        }
    }
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
    var containerView: FooterContainerView
    var action: (() -> Void)?
    
    // Values
    var defaultContentInset = UIEdgeInsets()
    var defaultHeightToTrigger: CGFloat = 0
    // 是否在底部留出bottom inset，还是直接黏着内容，紧跟contentSize
    var stickToContent = true {
        didSet {
            adjustFooterFrame()
        }
    }
    
    init(height: CGFloat, animator: CustomInfinityScrollAnimator) {
        self.defaultHeightToTrigger = height
        self.animator = animator
        self.containerView = FooterContainerView()
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
    private var lastOffset = CGPoint()
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &KVOContext {
            if keyPath == "contentSize" {
                adjustFooterFrame()
            }
            else if keyPath == "contentInset" {
                guard !self.scrollView!.lockInset else {
                    return
                }
                defaultContentInset = change!["new"]!.UIEdgeInsetsValue()
                adjustFooterFrame()
            }
            else if keyPath == "contentOffset" {
                let point = change!["new"]!.CGPointValue
                
                guard lastOffset.y != point.y else {
                    return
                }
                guard !updatingState else {
                    return
                }

                var distance: CGFloat = 0
                if stickToContent {
                    distance = scrollView!.contentSize.height - point.y - scrollView!.frame.height
                }else {
                    distance = scrollView!.contentSize.height + self.defaultContentInset.bottom - point.y - scrollView!.frame.height
                }
                // 要保证scrollView里面是有内容的, 且保证是在上滑
                if distance < 0 && self.state != .Loading && scrollView!.contentSize.height > 0 && point.y > lastOffset.y {
                    self.state = .Loading
                }
                
                lastOffset = point
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    var lockInset = false
    var updatingState = false
    var state: InfinityScrollState = .None {
        didSet {
            self.animator.animateState(state)
            switch state {
            case .Loading where oldValue == .None:
                
                updatingState = true
                var jumpToBottom: CGFloat = 0
                if self.stickToContent {
                    jumpToBottom = self.defaultHeightToTrigger
                }else {
                    jumpToBottom = self.defaultHeightToTrigger + self.defaultContentInset.bottom
                }
                let inset = UIEdgeInsets(top: self.defaultContentInset.top, left: self.defaultContentInset.left, bottom: jumpToBottom, right: self.defaultContentInset.right)
                self.scrollView?.setContentInset(inset, completion: { (finished) -> Void in
                    self.updatingState = false
                })
                action?()
            case .None where oldValue == .Loading:
                self.updatingState = true
                self.scrollView?.setContentInset(self.defaultContentInset, completion: { (finished) -> Void in
                    self.updatingState = false
                })
            default:
                break
            }
        }
    }
    
    func adjustFooterFrame() {
        if let scrollView = scrollView {
            if stickToContent {
                containerView.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.width, height: defaultHeightToTrigger)
            }else {
                containerView.frame = CGRect(x: 0, y: scrollView.contentSize.height + self.defaultContentInset.bottom, width: scrollView.bounds.width, height: defaultHeightToTrigger)
            }
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

class FooterContainerView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            view.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
    }
}
