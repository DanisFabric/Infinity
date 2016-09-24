//
//  DefaultInfinityAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

open class DefaultInfiniteAnimator: UIView, CustomInfiniteScrollAnimator {

    open var activityIndicatorView: UIActivityIndicatorView
    open fileprivate(set) var animating: Bool = false
    
    public override init(frame: CGRect) {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
        
        super.init(frame: frame)
        
        self.addSubview(activityIndicatorView)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicatorView.frame = self.bounds
    }
    open override func didMoveToWindow() {
        if window != nil && animating {
            startAnimating()
        }
    }
    open func animateState(_ state: InfiniteScrollState) {
        print(state)
        switch state {
        case .none:
            stopAnimating()
        case .loading:
            startAnimating()
        }
    }
    func startAnimating() {
        animating = true
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }
    func stopAnimating() {
        animating = false
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
