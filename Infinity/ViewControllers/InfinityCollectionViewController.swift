//
//  InfinityCollectionViewController.swift
//  InfinitySample
//
//  Created by Danis on 16/3/15.
//  Copyright © 2016年 danis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

public class InfinityCollectionViewController: UICollectionViewController {
    
    public var infinity = true {
        didSet {
            collectionView?.enableInfiniteScroll = infinity
        }
    }
    public func checkInfinity(count: Int, withPageLimit limit: Int) {
        infinity = !(count < limit)
    }
    
    public func addPullToRefresh(height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator) {
        collectionView?.addPullToRefresh(height, animator: animator, action: { () -> Void in
            self.didPullToRefresh()
        })
    }
    public func addInfiniteScroll(height: CGFloat = 60.0, animator: CustomInfiniteScrollAnimator) {
        collectionView?.addInfiniteScroll(height, animator: animator, action: { () -> Void in
            self.didInfiniteScroll()
        })
    }

    public func removePullToRefresh() {
        collectionView?.removePullToRefresh()
    }
    public func removeInfiniteScroll() {
        collectionView?.removeInfiniteScroll()
    }
    public func beginRefreshing() {
        collectionView?.beginRefreshing()
    }
    public func endRefreshing() {
        collectionView?.endRefreshing()
    }
    public func beginInfiniteScrolling() {
        collectionView?.beginInfiniteScrolling()
    }
    public func endInfinityScrolling() {
        collectionView?.endInfiniteScrolling()
    }
    public func didPullToRefresh() {
        
    }
    public func didInfiniteScroll() {
        
    }
}
