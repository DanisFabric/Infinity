//
//  CircleInfiniteAnimator.swift
//  InfiniteSample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

open class CircleInfiniteAnimator: UIView, CustomInfiniteScrollAnimator {

    var circle: CAShapeLayer = CAShapeLayer()
    fileprivate(set) var animating = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        circle.fillColor = UIColor.darkGray.cgColor
        circle.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).cgPath
        circle.transform = CATransform3DMakeScale(0, 0, 0)
        
        self.layer.addSublayer(circle)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        circle.frame = self.bounds
    }
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil && animating {
            startAnimating()
        }
    }
    
    open func animateState(_ state: InfiniteScrollState) {
        switch state {
        case .none:
            stopAnimating()
        case .loading:
            startAnimating()
        }
    }
    
    fileprivate let CircleAnimationKey = "CircleAnimationKey"
    func startAnimating() {
        animating = true
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        let animGroup = CAAnimationGroup()
        
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1.0
        scaleAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0
        opacityAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        animGroup.duration = 1.0
        animGroup.repeatCount = 1000
        animGroup.animations = [scaleAnim,opacityAnim]
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = CAMediaTimingFillMode.forwards
        
        self.circle.add(animGroup, forKey: CircleAnimationKey)
    }
    func stopAnimating() {
        animating = false
        
        self.circle.removeAnimation(forKey: CircleAnimationKey)
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
