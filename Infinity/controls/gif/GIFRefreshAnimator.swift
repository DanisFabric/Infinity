//
//  GIFRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class GIFRefreshAnimator: UIView, CustomPullToRefreshAnimator {
    
    public var refreshImages:[UIImage]?
    public var animatedImages:[UIImage]? {
        didSet {
            imageView.animationImages = animatedImages
        }
    }
    
    private var imageView:UIImageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        
        self.addSubview(imageView)
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
        if let refreshImages = refreshImages {
            let currentIndex = min(Int(progress * CGFloat(refreshImages.count)), refreshImages.count - 1)
            imageView.image = refreshImages[currentIndex]
        }
    }
    func startAnimating() {
        imageView.startAnimating()
    }
    func stopAnimating() {
        imageView.stopAnimating()
        imageView.image = refreshImages?.first
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
