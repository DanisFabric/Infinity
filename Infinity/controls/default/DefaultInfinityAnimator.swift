//
//  DefaultInfinityAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class DefaultInfiniteAnimator: UIView, CustomInfiniteScrollAnimator {

    public var activityIndicatorView: UIActivityIndicatorView
    public private(set) var animating: Bool = false
    
    public override init(frame: CGRect) {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.hidden = true
        
        super.init(frame: frame)
        
        self.addSubview(activityIndicatorView)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicatorView.frame = self.bounds
    }
    public override func didMoveToWindow() {
        if window != nil && animating {
            startAnimating()
        }
    }
    public func animateState(state: InfiniteScrollState) {
        print(state)
        switch state {
        case .None:
            stopAnimating()
        case .Loading:
            startAnimating()
        }
    }
    func startAnimating() {
        animating = true
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidden = false
    }
    func stopAnimating() {
        animating = false
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidden = true
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
