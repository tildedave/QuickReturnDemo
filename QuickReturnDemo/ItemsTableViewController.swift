//
//  ViewController.swift
//  QuickReturnDemo
//
//  Created by Dave King on 7/2/16.
//  Copyright © 2016 Dave King. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    var scrollDelegate: UIScrollViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Bananas 🍌"

        return cell
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let scrollDelegate = self.scrollDelegate {
            scrollDelegate.scrollViewDidScroll!(scrollView)
        }
    }
}
