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
    var direction: InfinityScrollDirection
    var action: (() -> Void)?
    var enable = true
    
    // Values
    var defaultContentInset = UIEdgeInsets()
    var defaultDistanceToTrigger: CGFloat = 0
    // 是否在底部留出bottom inset，还是直接黏着内容，紧跟contentSize
    var stickToContent = true {
        didSet {
            adjustFooterFrame()
        }
    }
    
    init(height: CGFloat, direction: InfinityScrollDirection, animator: CustomInfiniteScrollAnimator) {
        self.defaultDistanceToTrigger = height
        self.animator = animator
        self.containerView = FooterContainerView()
        self.direction = direction
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
                
                if direction == .vertical{
                    guard lastOffset.y != point.y else {
                        return
                    }
                }
                else{
                    guard lastOffset.x != point.x else {
                        return
                    }
                }
                guard !updatingState && enable else {
                    return
                }

                var distance: CGFloat = 0
                
                switch (direction, stickToContent){
                    case (.vertical, true):
                        distance = scrollView!.contentSize.height - point.y - scrollView!.frame.height
                    case (.vertical, false):
                    distance = scrollView!.contentSize.height + self.defaultContentInset.bottom - point.y - scrollView!.frame.height
                    case (.horizontal, true):
                    distance = scrollView!.contentSize.width - point.x - scrollView!.frame.width
                    case (.horizontal, false):
                    distance = scrollView!.contentSize.width + self.defaultContentInset.right - point.x - scrollView!.frame.width
                    default: return
                }

                // 要保证scrollView里面是有内容的, 且保证是在上滑
                if self.state != .loading{
                    var verticalShouldLoad: Bool = distance < 0 && scrollView!.contentSize.height > 0 && point.y > lastOffset.y
                    var horizontalShouldLoad: Bool = distance < 0 && scrollView!.contentSize.width > 0 && point.x > lastOffset.x
                    var shouldLoad: Bool = direction == .vertical ? verticalShouldLoad : horizontalShouldLoad
                    if shouldLoad{
                        self.state = .loading
                    }
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
                    var inset: UIEdgeInsets!
                    if self.direction == .vertical{
                        let jumpToBottom = self.defaultDistanceToTrigger + self.defaultContentInset.bottom
                        inset = UIEdgeInsets(top: self.defaultContentInset.top, left: self.defaultContentInset.left, bottom: jumpToBottom, right: self.defaultContentInset.right)
                    }
                    else{
                        let jumpToBottom = self.defaultDistanceToTrigger + self.defaultContentInset.right
                        inset = UIEdgeInsets(top: self.defaultContentInset.top, left: self.defaultContentInset.left, bottom: self.defaultContentInset.bottom, right: jumpToBottom)
                    }
                    
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
            containerView.frame = containerFrame(scrollView: scrollView)
        }
    }
    
    func containerFrame(scrollView: UIScrollView) -> CGRect{
        switch (direction, stickToContent){
            case (.vertical, true):
                return CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.width, height: defaultDistanceToTrigger)
            case (.vertical, false):
                return CGRect(x: 0, y: scrollView.contentSize.height + self.defaultContentInset.bottom, width: scrollView.bounds.width, height: defaultDistanceToTrigger)
            case (.horizontal, true):
                return CGRect(x: scrollView.contentSize.width, y: 0, width: defaultDistanceToTrigger, height: scrollView.bounds.height)
            case (.horizontal, false):
                return CGRect(x: scrollView.contentSize.width + self.defaultContentInset.right, y: 0, width: defaultDistanceToTrigger, height: scrollView.bounds.height)
            default: return CGRect.zero
        }
        
    }
    
    // MARK: - Infinity Scroll
    func beginInfiniteScrolling() {
        if direction == .vertical{
            scrollView?.setContentOffset(CGPoint(x: 0, y: (scrollView!.contentSize.height + defaultContentInset.bottom - scrollView!.frame.height + defaultDistanceToTrigger)), animated: true)
        }
        else{
            scrollView?.setContentOffset(CGPoint(x: (scrollView!.contentSize.width + defaultContentInset.right - scrollView!.frame.width + defaultDistanceToTrigger), y: 0), animated: true)
        }
        
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
