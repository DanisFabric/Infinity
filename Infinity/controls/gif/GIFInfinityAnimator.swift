//
//  GIFInfinityAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class GIFInfiniteAnimator: UIView, CustomInfiniteScrollAnimator {
    
    public var animatedImages:[UIImage]? {
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
    
    public func animateState(state: InfiniteScrollState) {
        switch state {
        case .Loading:
            startAnimating()
        case .None:
            stopAnimating()
        }
    }
    func startAnimating() {
        imageView.hidden = false
        imageView.startAnimating()
    }
    func stopAnimating() {
        imageView.hidden = true
        imageView.stopAnimating()
    }

}
