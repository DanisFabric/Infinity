//
//  SparkRefreshAnimator.swift
//  InfinitySample
//
//  Created by Danis on 15/12/23.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class SparkRefreshAnimator: UIView {

    public private(set) var animating = false
//    var circles:[CAShapeLayer]
    
    public override init(frame: CGRect) {
        
        
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
