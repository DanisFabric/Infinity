//
//  SamplesTableViewController.swift
//  InfinitySample
//
//  Created by Danis on 15/12/22.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit
import Infinity

class AddSamplesTableViewController: UITableViewController {

    var type:AnimatorType = .Default
    var items = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SampleCell")
        self.tableView.supportSpringBounces = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = InfinityContentInset.NavigationBar
        
        addPullToRefresh(type)
        addInfinityScroll(type)
        self.tableView.infinityStickToContent = true
    }

    deinit {
        self.tableView.removePullToRefresh()
        self.tableView.removeInfinityScroll()
    }
    
    // MARK: - Add PullToRefresh
    func addPullToRefresh(type: AnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            addPullToRefreshWithAnimator(animator)
        case .GIF:
            let animator = GIFRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            // Add Images for Animator
            var refreshImages = [UIImage]()
            for var index = 0; index <= 21; index++ {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    refreshImages.append(image)
                }
            }
            var animatedImages = [UIImage]()
            for var index = 21; index <= 29; index++ {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            for var index = 0; index < 21; index++ {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.refreshImages = refreshImages
            animator.animatedImages = animatedImages
            addPullToRefreshWithAnimator(animator)
        case .Circle:
            let animator = CircleRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            addPullToRefreshWithAnimator(animator)
        case .Arrow:
            let animator = ArrowRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            addPullToRefreshWithAnimator(animator)
//        case .Snake:
//            let animator = SnakeInfinityAnimator
        default:
            break
        }
    }
    func addPullToRefreshWithAnimator(animator: CustomPullToRefreshAnimator) {
        self.tableView.addPullToRefresh(animator: animator, action: { () -> Void in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.tableView?.endRefreshing()
            }
        })
    }
    // MARK: - Add InfinityScroll
    func addInfinityScroll(type: AnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfinityScrollWithAnimator(animator)
        case .GIF:
            let animator = GIFInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            var animatedImages = [UIImage]()
            for var index = 0; index <= 29; index++ {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.animatedImages = animatedImages
            addInfinityScrollWithAnimator(animator)
        case .Circle:
            let animator = CircleInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfinityScrollWithAnimator(animator)
        case .Snake:
            let animator = SnakeInfinityAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
            addInfinityScrollWithAnimator(animator)
        default:
            break
        }
    }
    func addInfinityScrollWithAnimator(animator: CustomInfinityScrollAnimator) {
        self.tableView.addInfinityScroll(animator: animator, action: { () -> Void in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(20 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.items += 15
                self.tableView.reloadData()
                self.tableView?.endInfinityScrolling()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SampleCell", forIndexPath: indexPath)

        cell.textLabel?.text = "Cell"

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = UIViewController()
        newVC.view.backgroundColor = UIColor.redColor()
        
        self.showViewController(newVC, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
