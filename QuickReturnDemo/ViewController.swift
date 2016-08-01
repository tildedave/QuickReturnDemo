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

        self.addChildViewController(tableViewController)
        let tableView = tableViewController.tableView
        tableView.frame = containerView.frame
        tableView.setNeedsLayout()
        self.containerView.addSubview(tableView)

        let headerFrame = self.headerView.frame
        let edgeInsets = UIEdgeInsets(top: headerFrame.origin.y + headerFrame.height, left: 0, bottom: 0, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
    }

    func heightAboveTable() -> CGFloat {
        return bannerView.frame.height + headerView.frame.height
    }

    var stickyScrollPosition: CGFloat = 0.0
    var previousScrollPosition: CGFloat = 0.0

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let bannerHeight = bannerView.frame.height
        let headerHeight = headerView.frame.height

        let pushDown = heightAboveTable()

        let scrollOffset = scrollView.contentOffset.y
        let pushUp = -(scrollOffset + pushDown)

        let hasScrolledUp = self.previousScrollPosition > scrollOffset

        // Banner has no special "quick return" behavior, it just scrolls up by the
        // amount that it needs to
        bannerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)

        if !hasScrolledUp {
            stickyScrollPosition = scrollOffset
        }

        if scrollOffset < bannerHeight - pushDown {
            // Banner still visible, so there's no special header behavior (just scroll it up)
            headerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)
            stickyScrollPosition = 0.0
        } else {
            // Banner is invisible, so we could be in a few different situations
            // * the user is scrolling down without ever having scrolled up
            // * the user is scrolling up, so we should show part of the header
            // * the user is scrolling down and the header is already visible from a previous scroll up

            if scrollOffset < stickyScrollPosition {
                // The header is visible as part of the "quick return" pattern

                var headerTransform = CATransform3DIdentity
                // By default transform the bottom of the header to the top of the view
                headerTransform = CATransform3DTranslate(headerTransform, 0, -(bannerHeight + headerHeight), 0)


                // As we scroll up, down
                let amountShowing = min(headerHeight, stickyScrollPosition - scrollOffset)
                headerTransform = CATransform3DTranslate(headerTransform, 0, amountShowing, 0)

                if abs(headerHeight - amountShowing) < 0.0001 {
                    stickyScrollPosition = scrollOffset + headerHeight
                }

                headerView.layer.transform = headerTransform
            } else {
                // No sticky scroll position, so we just want to generally transform the views up.
                // We need to transform the headerView so we handle the situation where the greeting is hidden
                // (scrolled past) but the header is still visible.
                // We could probably avoid transforming the views where pushUp is greater than pushDown but (as
                // we're just generally sending the views further and further off the page) but this simplifies
                // the code slightly and I'm not aware of any drawbacks to this approach

                headerView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, pushUp, 0)

                let hasScrolledUp = self.previousScrollPosition > scrollOffset
                if !hasScrolledUp {
                    // We don't want to set the sticky scroll position beyond the bottom of the scrollOffset
                    // The maximum value of the content offset is the difference between the content size and
                    // the bounds of the view, see more at https://www.objc.io/issues/3-views/scroll-view/
                    stickyScrollPosition = min(scrollOffset, scrollView.contentSize.height -  scrollView.bounds.height)
                }
            }
        }

        self.previousScrollPosition = scrollOffset
    }
}
