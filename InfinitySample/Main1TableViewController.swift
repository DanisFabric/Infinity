//
//  Samples1TableViewController.swift
//  InfinitySample
//
//  Created by Danis on 15/12/22.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

class Main1TableViewController: UITableViewController {

    var samples = ["Default","Circle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
        return samples.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SampleCell", forIndexPath: indexPath)

        cell.textLabel?.text = samples[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sampleVC = SamplesTableViewController()
        sampleVC.hidesBottomBarWhenPushed = true
        sampleVC.type = indexPath.row
        
        self.showViewController(sampleVC, sender: self)
    }

}
