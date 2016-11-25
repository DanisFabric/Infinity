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
    var items = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "refresh", style: .plain, target: self, action: #selector(startRefreshing(sender:)))
        
        view.backgroundColor = .white
        title = type.description
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SampleCell")
        tableView.supportSpringBounces = true
        
        automaticallyAdjustsScrollViewInsets = false
//        tableView.contentInset = InfiniteContentInset.NavigationBar
        tableView.setInsetType(withTop: .navigationBar, bottom: .none)
        
        addPullToRefresh(type: type)
        addInfiniteScroll(type: type)
        tableView.infiniteStickToContent = true
        
//        tableView.enablePullToRefresh = false
//        tableView.enableInfiniteScroll = false
    }

    deinit {
        tableView.removePullToRefresh()
        tableView.removeInfiniteScroll()
    }
    
    
    func startRefreshing(sender: AnyObject) {
        tableView.beginRefreshing()
    }
    
    // MARK: - Add PullToRefresh
    func addPullToRefresh(type: AnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            addPullToRefreshWithAnimator(animator: animator)
        case .GIF:
            let animator = GIFRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            // Add Images for Animator
            var refreshImages = [UIImage]()
            for index in 0..<22 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    refreshImages.append(image)
                }
            }
            var animatedImages = [UIImage]()
            for index in 21..<30 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            for index in 0..<22 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.refreshImages = refreshImages
            animator.animatedImages = animatedImages
            addPullToRefreshWithAnimator(animator: animator)
        case .Circle:
            let animator = CircleRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            addPullToRefreshWithAnimator(animator: animator)
        case .Arrow:
            let animator = ArrowRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            animator.color = .red
            addPullToRefreshWithAnimator(animator: animator)
        case .Snake:
            let animator = SnakeRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
            addPullToRefreshWithAnimator(animator: animator)
        case .Spark:
            let animator = SparkRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            addPullToRefreshWithAnimator(animator: animator)
        default:
            break
        }
    }
    func addPullToRefreshWithAnimator(animator: CustomPullToRefreshAnimator) {
        tableView.addPullToRefresh(animator: animator, action: { [unowned self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("end refreshing")
                
                self.items += 3
                self.tableView.reloadData()
                self.tableView?.endRefreshing()
                
                if self.items < 12 {
                    self.tableView.enableInfiniteScroll = false
                } else {
                    self.tableView.enableInfiniteScroll = true
                }
            }
        })
    }
    // MARK: - Add InfiniteScroll
    func addInfiniteScroll(type: AnimatorType) {
        switch type {
        case .Default:
            let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfiniteScrollWithAnimator(animator: animator)
        case .GIF:
            let animator = GIFInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            var animatedImages = [UIImage]()
            for index in 0..<30 {
                let image = UIImage(named: "hud_\(index)")
                if let image = image {
                    animatedImages.append(image)
                }
            }
            animator.animatedImages = animatedImages
            addInfiniteScrollWithAnimator(animator: animator)
        case .Circle:
            let animator = CircleInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            addInfiniteScrollWithAnimator(animator: animator)
        case .Snake:
            let animator = SnakeInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
            addInfiniteScrollWithAnimator(animator: animator)
        default:
            break
        }
    }
    func addInfiniteScrollWithAnimator(animator: CustomInfiniteScrollAnimator) {
        tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self?.items += 15
                self?.tableView.reloadData()
                self?.tableView?.endInfiniteScrolling()
            }
        })
        tableView.enableInfiniteScroll = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)

        cell.textLabel?.text = "Cell"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = UIViewController()
        newVC.view.backgroundColor = .red
        
        show(newVC, sender: self)
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
