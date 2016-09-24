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

open class ArrowRefreshAnimator: UIView, CustomPullToRefreshAnimator {
    
    fileprivate(set) var animating = false
    open var color: UIColor = UIColor.ArrowBlue {
        didSet {
            arrowLayer.strokeColor = color.cgColor
            circleFrontLayer.strokeColor = color.cgColor
            activityIndicatorView.color = color
        }
    }
    
    fileprivate var arrowLayer:CAShapeLayer = CAShapeLayer()
    fileprivate var circleFrontLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var circleBackLayer: CAShapeLayer = CAShapeLayer()
    
    fileprivate var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleBackLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).cgPath
        circleBackLayer.fillColor = nil
        circleBackLayer.strokeColor = UIColor.ArrowLightGray.cgColor
        circleBackLayer.lineWidth = 3
        
        circleFrontLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).cgPath
        circleFrontLayer.fillColor = nil
        circleFrontLayer.strokeColor = color.cgColor
        circleFrontLayer.lineWidth = 3
        circleFrontLayer.lineCap = kCALineCapRound
        circleFrontLayer.strokeStart = 0
        circleFrontLayer.strokeEnd = 0
        circleFrontLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-M_PI_2)))
        
        let arrowWidth = min(frame.width, frame.height) / 2
        let arrowHeight = arrowWidth * 0.5
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 0, y: arrowHeight))
        arrowPath.addLine(to: CGPoint(x: arrowWidth / 2, y: 0))
        arrowPath.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight))
        
        arrowLayer.path = arrowPath.cgPath
        arrowLayer.fillColor = nil
        arrowLayer.strokeColor = color.cgColor
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
    open func animateState(_ state: PullToRefreshState) {
        switch state {
        case .none:
            stopAnimating()
        case .releasing(let progress):
            updateForProgress(progress)
        case .loading:
            startAnimating()
        }
    }
    func updateForProgress(_ progress: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleFrontLayer.strokeEnd = progress * progress
        arrowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(M_PI * 2) * progress * progress))
        CATransaction.commit()
    }
    func startAnimating() {
        animating = true
        circleFrontLayer.strokeEnd = 0
        arrowLayer.transform = CATransform3DIdentity
        
        circleBackLayer.isHidden = true
        circleFrontLayer.isHidden = true
        arrowLayer.isHidden = true
        
        activityIndicatorView.startAnimating()
    }
    func stopAnimating() {
        animating = false
        
        circleBackLayer.isHidden = false
        circleFrontLayer.isHidden = false
        arrowLayer.isHidden = false
        
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
