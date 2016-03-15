//
//  ArrowRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/24.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

extension UIColor {
    static var ArrowBlue: UIColor {
        return UIColor(red: 76/255.0, green: 143/255.0, blue: 1.0, alpha: 1.0)
    }
    static var ArrowLightGray: UIColor {
        return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
    }
}

public class ArrowRefreshAnimator: UIView, CustomPullToRefreshAnimator {
    
    private(set) var animating = false
    public var color: UIColor = UIColor.ArrowBlue {
        didSet {
            arrowLayer.strokeColor = color.CGColor
            circleFrontLayer.strokeColor = color.CGColor
            activityIndicatorView.color = color
        }
    }
    
    private var arrowLayer:CAShapeLayer = CAShapeLayer()
    private var circleFrontLayer: CAShapeLayer = CAShapeLayer()
    private var circleBackLayer: CAShapeLayer = CAShapeLayer()
    
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleBackLayer.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).CGPath
        circleBackLayer.fillColor = nil
        circleBackLayer.strokeColor = UIColor.ArrowLightGray.CGColor
        circleBackLayer.lineWidth = 3
        
        circleFrontLayer.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).CGPath
        circleFrontLayer.fillColor = nil
        circleFrontLayer.strokeColor = color.CGColor
        circleFrontLayer.lineWidth = 3
        circleFrontLayer.lineCap = kCALineCapRound
        circleFrontLayer.strokeStart = 0
        circleFrontLayer.strokeEnd = 0
        circleFrontLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(CGFloat(-M_PI_2)))
        
        let arrowWidth = min(frame.width, frame.height) / 2
        let arrowHeight = arrowWidth * 0.5
        
        let arrowPath = UIBezierPath()
        arrowPath.moveToPoint(CGPoint(x: 0, y: arrowHeight))
        arrowPath.addLineToPoint(CGPoint(x: arrowWidth / 2, y: 0))
        arrowPath.addLineToPoint(CGPoint(x: arrowWidth, y: arrowHeight))
        
        arrowLayer.path = arrowPath.CGPath
        arrowLayer.fillColor = nil
        arrowLayer.strokeColor = color.CGColor
        arrowLayer.lineWidth = 3
        arrowLayer.lineJoin = kCALineJoinRound
        arrowLayer.lineCap = kCALineCapButt
        
        circleBackLayer.frame = self.bounds
        circleFrontLayer.frame = self.bounds
        arrowLayer.frame = CGRect(x: (frame.width - arrowWidth)/2, y: (frame.height - arrowHeight)/2, width: arrowWidth, height: arrowHeight)
        
        activityIndicatorView.frame = self.bounds
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.ArrowBlue
        
        self.layer.addSublayer(circleBackLayer)
        self.layer.addSublayer(circleFrontLayer)
        self.layer.addSublayer(arrowLayer)
        self.addSubview(activityIndicatorView)
        
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func animateState(state: PullToRefreshState) {
        switch state {
        case .None:
            stopAnimating()
        case .Releasing(let progress):
            updateForProgress(progress)
        case .Loading:
            startAnimating()
        }
    }
    func updateForProgress(progress: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleFrontLayer.strokeEnd = progress * progress
        arrowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI * 2) * progress * progress))
        CATransaction.commit()
    }
    func startAnimating() {
        animating = true
        circleFrontLayer.strokeEnd = 0
        arrowLayer.transform = CATransform3DIdentity
        
        circleBackLayer.hidden = true
        circleFrontLayer.hidden = true
        arrowLayer.hidden = true
        
        activityIndicatorView.startAnimating()
    }
    func stopAnimating() {
        animating = false
        
        circleBackLayer.hidden = false
        circleFrontLayer.hidden = false
        arrowLayer.hidden = false
        
        activityIndicatorView.stopAnimating()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
