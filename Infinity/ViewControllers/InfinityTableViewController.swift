//
//  InfinityTableViewController.swift
//  InfinitySample
//
//  Created by Danis on 16/3/8.
//  Copyright © 2016年 danis. All rights reserved.
//

import UIKit

open class InfinityTableViewController: UITableViewController {
    
    open var infinity = true {
        didSet {
            tableView.enableInfiniteScroll = infinity
        }
    }
    open func checkInfinity(_ count: Int, withPageLimit limit: Int) {
        infinity = !(count < limit)
    }
    
    
    open func addPullToRefresh(_ height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator) {
        tableView.addPullToRefresh(height, animator: animator) { [unowned self]() -> Void in
            self.didPullToRefresh()
        }
    }
    open func addInfiniteScroll(_ height: CGFloat = 60.0, animator: CustomInfiniteScrollAnimator) {
        tableView.addInfiniteScroll(height, animator: animator) { [unowned self] () -> Void in
            self.didInfiniteScroll()
        }
    }
    
    open func removePullToRefresh() {
        tableView.removePullToRefresh()
    }
    open func removeInfiniteScroll() {
        tableView.removeInfiniteScroll()
    }
    open func beginRefreshing() {
        tableView.beginRefreshing()
    }
    open func endRefreshing() {
        tableView.endRefreshing()
    }
    open func beginInfiniteScrolling() {
        tableView.beginInfiniteScrolling()
    }
    open func endInfinityScrolling() {
        tableView.endInfiniteScrolling()
    }
    
    // MARK: - Callback
    
    open func didPullToRefresh() {
        
    }
    open func didInfiniteScroll() {
        
    }
}
