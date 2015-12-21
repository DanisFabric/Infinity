//
//  ViewController.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit
import Infinity

class TestAnimator: UIView, CustomPullToRefreshAnimator {
    func animateState(state: PullToRefreshState) {
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
        
        let testAnimator = TestAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.tableView?.addPullToRefresh(animator: testAnimator, action: { () -> Void in
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.tableView?.endRefreshing()
            }
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
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
        let newVC = UIViewController()
        newVC.view.backgroundColor = UIColor.blueColor()
        newVC.automaticallyAdjustsScrollViewInsets = true
        self.showViewController(newVC, sender: self)
    }
}

