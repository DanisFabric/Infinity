//
//  GIFInfinityAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

open class GIFInfiniteAnimator: UIView, CustomInfiniteScrollAnimator {
    
    open var animatedImages:[UIImage]? {
        didSet {
            imageView.animationImages = animatedImages
        }
    }
    
    var imageView: UIImageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        self.addSubview(imageView)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func animateState(_ state: InfiniteScrollState) {
        switch state {
        case .loading:
            startAnimating()
        case .none:
            stopAnimating()
        }
    }
    func startAnimating() {
        imageView.isHidden = false
        imageView.startAnimating()
    }
    func stopAnimating() {
        imageView.isHidden = true
        imageView.stopAnimating()
    }

}
