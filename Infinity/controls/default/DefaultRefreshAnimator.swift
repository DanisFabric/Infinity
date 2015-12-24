//
//  DefaultRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class DefaultRefreshAnimator: UIView, CustomPullToRefreshAnimator {

    public var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    public var circleLayer: CAShapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        activityIndicatorView.hidden = true
        activityIndicatorView.hidesWhenStopped = true
        
        circleLayer.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).CGPath
        circleLayer.strokeColor = UIColor.grayColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 3
        circleLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(CGFloat(-M_PI/2)))
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
        
        self.addSubview(activityIndicatorView)
        self.layer.addSublayer(circleLayer)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicatorView.frame = self.bounds
        circleLayer.frame = self.bounds
    }
    public func animateState(state: PullToRefreshState) {
        switch state {
        case .None:
            stopAnimating()
        case .Releasing(let progress):
            self.updateCircle(progress)
        case .Loading:
            startAnimating()
        }
    }
    func startAnimating() {
        circleLayer.hidden = true
        circleLayer.strokeEnd = 0
        
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()
    }
    func stopAnimating() {
        circleLayer.hidden = false
        
        activityIndicatorView.hidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func updateCircle(progress: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleLayer.strokeStart = 0
        // 为了让circle增长速度在开始时比较慢，后来加快，这样更好看
        circleLayer.strokeEnd = progress * progress
        CATransaction.commit()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
