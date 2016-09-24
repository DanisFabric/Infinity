//
//  DefaultRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

open class DefaultRefreshAnimator: UIView, CustomPullToRefreshAnimator {

    open var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    open var circleLayer: CAShapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.hidesWhenStopped = true
        
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).cgPath
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 3
        circleLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-M_PI/2)))
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
        
        self.addSubview(activityIndicatorView)
        self.layer.addSublayer(circleLayer)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicatorView.frame = self.bounds
        circleLayer.frame = self.bounds
    }
    open func animateState(_ state: PullToRefreshState) {
        switch state {
        case .none:
            stopAnimating()
        case .releasing(let progress):
            self.updateCircle(progress)
        case .loading:
            startAnimating()
        }
    }
    func startAnimating() {
        circleLayer.isHidden = true
        circleLayer.strokeEnd = 0
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    func stopAnimating() {
        circleLayer.isHidden = false
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func updateCircle(_ progress: CGFloat) {
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
