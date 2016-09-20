//
//  GIFRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

open class GIFRefreshAnimator: UIView, CustomPullToRefreshAnimator {
    
    open var refreshImages:[UIImage]?
    open var animatedImages:[UIImage]? {
        didSet {
            imageView.animationImages = animatedImages
        }
    }
    
    fileprivate var imageView:UIImageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        
        self.addSubview(imageView)
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
