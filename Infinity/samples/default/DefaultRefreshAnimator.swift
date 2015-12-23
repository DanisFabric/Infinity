//
//  DefaultRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class DefaultRefreshAnimator: UIView, CustomPullToRefreshAnimator {

    var activityIndicatorView: UIActivityIndicatorView
    var circleLayer: CAShapeLayer
    
    public override init(frame: CGRect) {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.hidden = true
        activityIndicatorView.hidesWhenStopped = true
        
        circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalInRect: frame).CGPath
        circleLayer.strokeColor = UIColor.grayColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 2
        
        super.init(frame: frame)
        
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
            circleLayer.hidden = true
            activityIndicatorView.hidden = true
            activityIndicatorView.stopAnimating()
        case .Releasing(let progress):
            circleLayer.hidden = false
            activityIndicatorView.hidden = true
            activityIndicatorView.stopAnimating()
            
            CATransaction.begin()
            self.updateCircle(progress)
            CATransaction.commit()
        case .Loading:
            circleLayer.hidden = true
            activityIndicatorView.hidden = false
            activityIndicatorView.startAnimating()
            
            break
        }
    }
    
    func updateCircle(progress: CGFloat) {
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = progress
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
