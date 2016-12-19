//
//  InfinityScroller.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public protocol CustomInfiniteScrollAnimator {
    func animateState(_ state: InfiniteScrollState)
}

public enum InfiniteScrollState: Equatable, CustomStringConvertible {
    case none
    case loading
    
    public var description: String {
        switch self {
        case .none: return "None"
        case .loading: return "Loading"
        }
    }
}
public func == (left: InfiniteScrollState, right: InfiniteScrollState) -> Bool {
    switch (left, right) {
    case (.none, .none): return true
    case (.loading, .loading): return true
    default:
        return false
    }
}

class InfiniteScroller: NSObject {
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
    var animator: CustomInfiniteScrollAnimator
    var containerView: FooterContainerView
    var action: (() -> Void)?
    var enable = true
    
    // Values
    var defaultContentInset = UIEdgeInsets()
    var defaultHeightToTrigger: CGFloat = 0
    // 是否在底部留出bottom inset，还是直接黏着内容，紧跟contentSize
    var stickToContent = true {
        didSet {
            adjustFooterFrame()
        }
    }
    
    init(height: CGFloat, animator: CustomInfiniteScrollAnimator) {
        self.defaultHeightToTrigger = height
        self.animator = animator
        self.containerView = FooterContainerView()
    }
    
    // MARK: - Observe Scroll View
    var KVOContext = "InfinityScrollKVOContext"
    func addScrollViewObserving(_ scrollView: UIScrollView?) {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: "contentInset", options: .new, context: &KVOContext)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: &KVOContext)
    }
    func removeScrollViewObserving(_ scrollView: UIScrollView?) {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentInset", context: &KVOContext)
        scrollView?.removeObserver(self, forKeyPath: "contentSize", context: &KVOContext)
    }
    fileprivate var lastOffset = CGPoint()
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContext {
            if keyPath == "contentSize" {
                adjustFooterFrame()
            }
            else if keyPath == "contentInset" {
                guard !self.scrollView!.lockInset else {
                    return
                }
                defaultContentInset = (change![.newKey]! as AnyObject).uiEdgeInsetsValue!
                adjustFooterFrame()
            }
            else if keyPath == "contentOffset" {
                let point = (change![.newKey]! as AnyObject).cgPointValue!
                
                guard lastOffset.y != point.y else {
                    return
                }
                guard !updatingState && enable else {
                    return
                }

                var distance: CGFloat = 0
                if stickToContent {
                    distance = scrollView!.contentSize.height - point.y - scrollView!.frame.height
                }else {
                    distance = scrollView!.contentSize.height + self.defaultContentInset.bottom - point.y - scrollView!.frame.height
                }
                // 要保证scrollView里面是有内容的, 且保证是在上滑
                if distance < 0 && self.state != .loading && scrollView!.contentSize.height > 0 && point.y > lastOffset.y {
                    self.state = .loading
                }
                
                lastOffset = point
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    var lockInset = false
    var updatingState = false
    var state: InfiniteScrollState = .none {
        didSet {
            self.animator.animateState(state)
            DispatchQueue.main.async {
                switch self.state {
                case .loading where oldValue == .none:
                    
                    self.updatingState = true
                    let jumpToBottom = self.defaultHeightToTrigger + self.defaultContentInset.bottom
                    let inset = UIEdgeInsets(top: self.defaultContentInset.top, left: self.defaultContentInset.left, bottom: jumpToBottom, right: self.defaultContentInset.right)
                    self.scrollView?.setContentInset(inset, completion: { [unowned self] (finished) -> Void in
                        self.updatingState = false
                    })
                    self.action?()
                case .none where oldValue == .loading:
                    self.updatingState = true
                    self.scrollView?.setContentInset(self.defaultContentInset, completion: { (finished) -> Void in
                        self.updatingState = false
                    })
                default:
                    break
                }
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
    func beginInfiniteScrolling() {
        scrollView?.setContentOffset(CGPoint(x: 0, y: (scrollView!.contentSize.height + defaultContentInset.bottom - scrollView!.frame.height + defaultHeightToTrigger)), animated: true)
    }
    func endInfiniteScrolling() {
        self.state = .none
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
