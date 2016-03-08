//
//  InfinityTableViewController.swift
//  InfinitySample
//
//  Created by Danis on 16/3/8.
//  Copyright © 2016年 danis. All rights reserved.
//

import UIKit

public class InfinityTableViewController: UITableViewController {
    
    public var infinity = true {
        didSet {
            tableView.enableInfiniteScroll = infinity
        }
    }
    public func checkInfinity(count: Int, withPageLimit limit: Int) {
        infinity = !(count < limit)
    }
    
    
    public func addPullToRefresh(height: CGFloat = 60.0, animator: CustomPullToRefreshAnimator) {
        tableView.addPullToRefresh(height, animator: animator) { [unowned self]() -> Void in
            self.didPullToRefresh()
        }
    }
    public func addInfiniteScroll(height: CGFloat = 60.0, animator: CustomInfiniteScrollAnimator) {
        tableView.addInfiniteScroll(height, animator: animator) { [unowned self] () -> Void in
            self.didInfiniteScroll()
        }
    }
    
    public func removePullToRefresh() {
        tableView.removePullToRefresh()
    }
    public func removeInfiniteScroll() {
        tableView.removeInfiniteScroll()
    }
    public func beginRefreshing() {
        tableView.beginRefreshing()
    }
    public func endRefreshing() {
        tableView.endRefreshing()
    }
    public func beginInfiniteScrolling() {
        tableView.beginInfiniteScrolling()
    }
    public func endInfinityScrolling() {
        tableView.endInfiniteScrolling()
    }
    
    // MARK: - Callback
    
    public func didPullToRefresh() {
        
    }
    public func didInfiniteScroll() {
        
    }
}
