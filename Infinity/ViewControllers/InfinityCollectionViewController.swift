//
//  InfinityCollectionViewController.swift
//  InfinitySample
//
//  Created by Danis on 16/3/15.
//  Copyright © 2016年 danis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

open class InfinityCollectionViewController: UICollectionViewController {
    
    open var infinity = true {
        didSet {
            collectionView?.enableInfiniteScroll = infinity
        }
    }
    open func checkInfinity(_ count: Int, withPageLimit limit: Int) {
        infinity = !(count < limit)
    }
    
    open func addPullToRefresh(_ height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator) {
        collectionView?.addPullToRefresh(height, animator: animator, action: { () -> Void in
            self.didPullToRefresh()
        })
    }
    open func addInfiniteScroll(_ height: CGFloat = 60.0, animator: CustomInfiniteScrollAnimator) {
        collectionView?.addInfiniteScroll(height, animator: animator, action: { () -> Void in
            self.didInfiniteScroll()
        })
    }

    open func removePullToRefresh() {
        collectionView?.removePullToRefresh()
    }
    open func removeInfiniteScroll() {
        collectionView?.removeInfiniteScroll()
    }
    open func beginRefreshing() {
        collectionView?.beginRefreshing()
    }
    open func endRefreshing() {
        collectionView?.endRefreshing()
    }
    open func beginInfiniteScrolling() {
        collectionView?.beginInfiniteScrolling()
    }
    open func endInfinityScrolling() {
        collectionView?.endInfiniteScrolling()
    }
    open func didPullToRefresh() {
        
    }
    open func didInfiniteScroll() {
        
    }
}
