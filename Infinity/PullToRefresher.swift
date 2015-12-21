//
//  PullToRefresher.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

public protocol CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState)
}

public enum PullToRefreshState {
    case None
    case Releasing(progress:CGFloat)
    case Loading
}

class PullToRefresher: NSObject {
    
}
