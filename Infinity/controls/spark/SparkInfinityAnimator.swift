//
//  SparkInfiniteAnimator.swift
//  InfiniteSample
//
//  Created by Danis on 16/1/2.
//  Copyright © 2016年 danis. All rights reserved.
//

import UIKit

open class SparkInfiniteAnimator: UIView, CustomInfiniteScrollAnimator {
    
    fileprivate var circles = [CAShapeLayer]()
    var animating = false
    
    fileprivate var positions = [CGPoint]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ovalDiameter = min(frame.width,frame.height) / 8
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ovalDiameter, height: ovalDiameter))
        
        let count = 8
        for index in 0..<count {
            let circleLayer = CAShapeLayer()
            circleLayer.path = ovalPath.cgPath
            circleLayer.fillColor = UIColor.sparkColorWithIndex(index).cgColor
            circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            self.circles.append(circleLayer)
            self.layer.addSublayer(circleLayer)
            
            let angle = CGFloat(M_PI * 2) / CGFloat(count) * CGFloat(index)
            
            let radius = min(frame.width, frame.height) * 0.4
            let position = CGPoint(x: bounds.midX + sin(angle) * radius, y: bounds.midY - cos(angle) * radius)
            circleLayer.position = position
            
            positions.append(position)
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func didMoveToWindow() {
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
    func startAnimating() {
        animating = true
        for index in 0..<8 {
            applyAnimationForIndex(index)
        }
    }
    fileprivate let CircleAnimationKey = "CircleAnimationKey"
    fileprivate func applyAnimationForIndex(_ index: Int) {
        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        let moveV1 = NSValue(cgPoint: positions[index])
        let moveV2 = NSValue(cgPoint: CGPoint(x: bounds.midX, y: bounds.midY))
        let moveV3 = NSValue(cgPoint: positions[index])
        moveAnimation.values = [moveV1,moveV2,moveV3]
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform")
        let scaleV1 = NSValue(caTransform3D: CATransform3DIdentity)
        let scaleV2 = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        let scaleV3 = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.values = [scaleV1,scaleV2,scaleV3]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [moveAnimation,scaleAnimation]
        animationGroup.duration = 1.0
        animationGroup.repeatCount = 1000
        animationGroup.beginTime = CACurrentMediaTime() + Double(index) * animationGroup.duration / 8 / 2
        animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 1, 0.5, 0, 0.5)
        
        let circleLayer = circles[index]
        circleLayer.isHidden = false
        circleLayer.add(animationGroup, forKey: CircleAnimationKey)
        
    }
    func stopAnimating() {
        for circleLayer in circles {
            circleLayer.removeAnimation(forKey: CircleAnimationKey)
            circleLayer.transform = CATransform3DIdentity
            circleLayer.isHidden = true
        }
        animating = false
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
