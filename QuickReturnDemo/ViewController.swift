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

        tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true

        let headerFrame = self.headerView.frame
        let edgeInsets = UIEdgeInsets(top: headerFrame.origin.y + headerFrame.height, left: 0, bottom: 0, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
    }

    var stickyScrollPosition: CGFloat = 0.0
    var previousScrollPosition: CGFloat = 0.0

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let bannerHeight = bannerView.frame.height
        let headerHeight = headerView.frame.height

        let pushDown = bannerHeight + headerHeight

        let scrollOffset = scrollView.contentOffset.y

        let hasScrolledUp = self.previousScrollPosition > scrollOffset

        if !hasScrolledUp {
            stickyScrollPosition = scrollOffset
        }

        if scrollOffset < bannerHeight - pushDown {
            print("banner visible")

            let pushUp = -(scrollOffset + pushDown)
            let bannerTransform = CATransform3DIdentity

            bannerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)
            headerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)

        } else if scrollOffset < (bannerHeight + headerHeight) - pushDown {
            print("banner invisible, header visible")

            // TODO: sticky scroll position needs to play in here

            let pushUp = -(scrollOffset + pushDown)
            bannerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)
            headerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)

        } else {
            print("neither banner inherently visible")

            if scrollOffset < stickyScrollPosition {
                var headerTransform = CATransform3DIdentity
                // By default transform the bottom of the header to the top of the view
                headerTransform = CATransform3DTranslate(headerTransform, 0, -(bannerHeight + headerHeight), 0)
                // As we scroll up, down
                headerTransform = CATransform3DTranslate(headerTransform, 0, min(headerHeight, stickyScrollPosition - scrollOffset), 0)

                headerView.layer.transform = headerTransform
                return
            }

            // If there's a sticky scroll position

            let pushUp = -(scrollOffset + pushDown)
            bannerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)
            headerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)
        }

        self.previousScrollPosition = scrollOffset
    }
}
