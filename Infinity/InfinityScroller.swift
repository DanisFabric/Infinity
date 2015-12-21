//
//  InfinityScroller.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public protocol CustomInfinityScrollAnimator {
    func animateState(state: InfinityScrollState)
}

public enum InfinityScrollState {
    case None
    case Loading
}

class InfinityScroller: NSObject {
    
}
