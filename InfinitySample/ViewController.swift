//
//  ViewController.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit
import Infinity

class HeaderAnimator: UIView, CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState) {
        print(state)
    }
}
class FooterAnimator: UIView, CustomInfinityScrollAnimator {
    func animateState(state: InfinityScrollState) {
        print(state)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = true
        
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        
        self.view.addSubview(tableView!)
        
        let headerAnimator = HeaderAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let footerAnimator = FooterAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        self.tableView?.addPullToRefresh(animator: headerAnimator, action: { () -> Void in
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.tableView?.endRefreshing()
            }
        })
        self.tableView?.addInfinityScroll(animator: footerAnimator, action: { () -> Void in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.tableView?.endInfinityScrolling()
            }
        })
        self.tableView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 100, right: 0)
        
        let rightItem = UIBarButtonItem(title: "refresh", style: .Bordered, target: self, action: "onRefresh:")
        self.navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(title: "load", style: .Bordered, target: self, action: "onLoadMore:")
        self.navigationItem.leftBarButtonItem = leftItem    
    }
    func onRefresh(sender: AnyObject) {
        self.tableView?.beginRefreshing()
    }
    func onLoadMore(sender: AnyObject) {
        self.tableView?.beginInfinityScrolling()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = "Cell"
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = NewViewController()

        self.showViewController(newVC, sender: self)
    }
}

