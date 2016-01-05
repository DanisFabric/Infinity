//
//  CircleRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit
import Infinity

class CircleRefreshAnimator: UIView, CustomPullToRefreshAnimator {

    var circle = CAShapeLayer()
    private(set) var animating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circle.fillColor = UIColor.darkGrayColor().CGColor
        circle.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).CGPath
        circle.transform = CATransform3DMakeScale(0, 0, 0)
        
        self.layer.addSublayer(circle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circle.frame = self.bounds
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil && animating {
            startAnimating()
        }
    }
    func animateState(state: PullToRefreshState) {
        switch state {
        case .None:
            stopAnimating()
        case .Releasing(let progress):
            updateCircle(progress)
        case .Loading:
            startAnimating()
        }
    }
    func updateCircle(progress: CGFloat) {
        circle.transform = CATransform3DMakeScale(progress, progress, progress)
    }
    
    private let CircleAnimationKey = "CircleAnimationKey"
    func startAnimating() {
        animating = true
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        let animGroup = CAAnimationGroup()
        
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1.0
        scaleAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0
        opacityAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        animGroup.duration = 1.0
        animGroup.repeatCount = 1000
        animGroup.animations = [scaleAnim,opacityAnim]
        animGroup.removedOnCompletion = false
        animGroup.fillMode = kCAFillModeForwards
        
        self.circle.addAnimation(animGroup, forKey: CircleAnimationKey)
    }
    func stopAnimating() {
        animating = false
        
        self.circle.removeAnimationForKey(CircleAnimationKey)
        self.circle.transform = CATransform3DMakeScale(0, 0, 0)
        self.circle.opacity = 1.0
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
