//
//  SnakeInfinityAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/26.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit
import Infinity

public class SnakeInfinityAnimator: UIView, CustomInfinityScrollAnimator {
    
    private var snakeLayer = CAShapeLayer()
    private var snakeLengthForCycle:CGFloat = 0 // 占的周期数
    private var cycleCount = 100
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ovalDiametor = frame.width / 4
        let lineHeight = frame.height - ovalDiametor
        
        snakeLengthForCycle = 2 - (ovalDiametor/2 * CGFloat(M_PI)) / ((lineHeight + ovalDiametor/2 * CGFloat(M_PI)) * 2)
        
        let snakePath = UIBezierPath()
        snakePath.moveToPoint(CGPoint(x: 0, y: frame.height - ovalDiametor/2))
        for index in 0...cycleCount {
            let cycleStartX = CGFloat(index) * ovalDiametor * 2
            snakePath.addLineToPoint(CGPoint(x: cycleStartX, y: ovalDiametor / 2))
            snakePath.addArcWithCenter(CGPoint(x: cycleStartX + ovalDiametor / 2, y: ovalDiametor / 2), radius: ovalDiametor / 2, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
            snakePath.addLineToPoint(CGPoint(x: cycleStartX + ovalDiametor, y: frame.height - ovalDiametor / 2))
            snakePath.addArcWithCenter(CGPoint(x: cycleStartX + ovalDiametor / 2 * 3, y: frame.height - ovalDiametor/2), radius: ovalDiametor/2, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: false)
        }
        snakeLayer.path = snakePath.CGPath
        snakeLayer.fillColor = nil
        snakeLayer.strokeColor = UIColor.blackColor().CGColor
        snakeLayer.strokeStart = 0
        snakeLayer.strokeEnd = snakeLengthForCycle / CGFloat(cycleCount)
        snakeLayer.lineWidth = 3
        snakeLayer.lineCap = kCALineCapRound
        
        snakeLayer.frame = self.bounds
        self.layer.addSublayer(snakeLayer)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animateState(state: InfinityScrollState) {
        switch state {
        case .None:
            stopAnimating()
        case .Loading:
            startAnimating()
        }
    }
    func startAnimating() {
        snakeLayer.strokeStart = 0
        snakeLayer.strokeEnd = snakeLengthForCycle / CGFloat(cycleCount)
        
        let strokeStartAnim = CABasicAnimation(keyPath: "strokeStart")
        let strokeEndAnim = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeStartAnim.toValue = 1 - snakeLengthForCycle/CGFloat(cycleCount)
        strokeEndAnim.toValue = 1

        let animGroup = CAAnimationGroup()
        animGroup.animations = [strokeStartAnim,strokeEndAnim]
        animGroup.duration = 100
        
        snakeLayer.addAnimation(animGroup, forKey: "StrokePathAnim")
        
    }
    func stopAnimating() {
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
