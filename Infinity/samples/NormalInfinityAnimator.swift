//
//  NormalInfinityView.swift
//  InfinitySample
//
//  Created by Danis on 15/12/22.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public class NormalInfinityAnimator : UIView, CustomInfinityScrollAnimator {

    var label: UILabel
    
    public override init(frame: CGRect) {
        label = UILabel()
        label.textAlignment = .Center
        
        super.init(frame: frame)
        
        self.addSubview(label)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.label.frame = self.bounds
    }
    public func animateState(state: InfinityScrollState) {
        label.text = state.description
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
