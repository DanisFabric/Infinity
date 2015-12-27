//
//  Main2TableViewController.swift
//  InfinitySample
//
//  Created by Danis on 15/12/22.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

enum BindAnimatorType: Int, CustomStringConvertible{
    case Default = 0
    case GIF
    case Circle
    case Arrow
    
    var description:String {
        switch self {
        case .Default:
            return "Default"
        case .GIF:
            return "GIF"
        case .Circle:
            return "Circle"
        case .Arrow:
            return "Arrow"
        }
    }
}


class Main2TableViewController: UITableViewController {
    
    var samples = [BindAnimatorType.Default,.GIF,.Circle,.Arrow]
    
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
        
        cell.textLabel?.text = samples[indexPath.row].description
        if indexPath.row <= 1 {
            cell.detailTextLabel?.text = "Built-In"
        }else {
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sampleVC = BindSamplesTableViewController()
        sampleVC.hidesBottomBarWhenPushed = true
        sampleVC.type = samples[indexPath.row]
        
        self.showViewController(sampleVC, sender: self)
    }


}
