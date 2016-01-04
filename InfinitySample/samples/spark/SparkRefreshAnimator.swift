//
//  SparkRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 16/1/2.
//  Copyright © 2016年 danis. All rights reserved.
//

import UIKit
import Infinity

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init(hex: Int) {
        self.init(hex:hex, alpha:1.0)
    }
    
    static func sparkColorWithIndex(index: Int) -> UIColor {
        switch index % 8 {
        case 0:
            return UIColor(hex: 0xf9b60f)
        case 1:
            return UIColor(hex: 0xf78a44)
        case 2:
            return UIColor(hex: 0xf05e4d)
        case 3:
            return UIColor(hex: 0xf75078)
        case 4:
            return UIColor(hex: 0xc973e4)
        case 5:
            return UIColor(hex: 0x1bbef1)
        case 6:
            return UIColor(hex: 0x5593f0)
        case 7:
            return UIColor(hex: 0x00cf98)
        default:
            return UIColor.clearColor()
        }
    }
}

class SparkRefreshAnimator: UIView, CustomPullToRefreshAnimator {
    
    private var circles = [CAShapeLayer]()
//    private var positions = [CGPoint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ovalDiameter = min(frame.width,frame.height) * 0.125
        let ovalPath = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: ovalDiameter, height: ovalDiameter))
        
        let count = 8
        for index in 0..<count {
            let circleLayer = CAShapeLayer()
            circleLayer.path = ovalPath.CGPath
            circleLayer.fillColor = UIColor.sparkColorWithIndex(index).CGColor
            
            self.circles.append(circleLayer)
            self.layer.addSublayer(circleLayer)
            
            let angle = CGFloat(M_PI * 2) / CGFloat(count) * CGFloat(index)
            print(angle)
            
            let radius = min(frame.width, frame.height) * 0.4
            let position = CGPoint(x: bounds.midX + sin(angle) * radius, y: bounds.midY - cos(angle) * radius)
            layer.position = position
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateState(state: PullToRefreshState) {
        
    }
}
