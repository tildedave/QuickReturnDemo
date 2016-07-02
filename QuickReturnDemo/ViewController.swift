//
//  ViewController.swift
//  QuickReturnDemo
//
//  Created by Dave King on 7/2/16.
//  Copyright © 2016 Dave King. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bannerView: UIView!

    let tableViewController: ItemsTableViewController

    required init?(coder aDecoder: NSCoder) {
        tableViewController = ItemsTableViewController(style: .Plain)

        super.init(coder: aDecoder)

        tableViewController.scrollDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = tableViewController.tableView
        self.addChildViewController(tableViewController)
        self.containerView.addSubview(tableView)

        let headerFrame = self.headerView.frame
        let edgeInsets = UIEdgeInsets(top: headerFrame.origin.y + headerFrame.height, left: 0, bottom: 0, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        print(scrollView.contentOffset)

        if scrollOffset < 0.0 {
//            var bannerTransform = CATransform3DIdentity
//            bannerTransform = CATransform3DTranslate(bannerTransform, 0, 500, 0)
//            bannerView.layer.transform = bannerTransform
        }
    }
}
