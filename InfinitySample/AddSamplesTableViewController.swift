//
//  SamplesTableViewController.swift
//  InfiniteSample
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
        
        view.backgroundColor = UIColor.whiteColor()
        title = type.description
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SampleCell")
        tableView.supportSpringBounces = true
        
        automaticallyAdjustsScrollViewInsets = false
//        tableView.contentInset = InfiniteContentInset.NavigationBar
        tableView.setInsetType(withTop: .NavigationBar, bottom: .None)
        
        addPullToRefresh(type)
        addInfiniteScroll(type)
        tableView.infiniteStickToContent = true
    }

    deinit {
        tableView.removePullToRefresh()
        tableView.removeInfiniteScroll()
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
        case .Snake:
            let animator = SnakeRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
            addPullToRefreshWithAnimator(animator)
        case .Spark:
            let animator = SparkRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            addPullToRefreshWithAnimator(animator)
        default:
            break
        }
    }
    func addPullToRefreshWithAnimator(animator: CustomPullToRefreshAnimator) {
        tableView.addPullToRefresh(animator: animator, action: { [weak self] () -> Void in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(2.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                print("end refreshing")
                self?.tableView?.endRefreshing()
            }
        })
    }
    // MARK: - Add InfiniteScroll
    func addInfiniteScroll(type: AnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfiniteScrollWithAnimator(animator)
        case .GIF:
            let animator = GIFInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            var animatedImages = [UIImage]()
            for var index = 0; index <= 29; index++ {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.animatedImages = animatedImages
            addInfiniteScrollWithAnimator(animator)
        case .Circle:
            let animator = CircleInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfiniteScrollWithAnimator(animator)
        case .Snake:
            let animator = SnakeInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
            addInfiniteScrollWithAnimator(animator)
        default:
            break
        }
    }
    func addInfiniteScrollWithAnimator(animator: CustomInfiniteScrollAnimator) {
        tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(2.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                print("end Infinite scrolling")
                self?.items += 15
                self?.tableView.reloadData()
                self?.tableView?.endInfiniteScrolling()
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
        
        showViewController(newVC, sender: self)
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
