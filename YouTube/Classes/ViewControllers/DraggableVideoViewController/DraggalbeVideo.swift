//
//  DraggalbeVideo.swift
//  YouTube
//
//  Created by Duy Tang on 9/2/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation

class DraggalbeVideo: UIViewController, UIGestureRecognizerDelegate {
    var thumbnailVideoContainerView: UIView = (UIApplication.sharedApplication().delegate as? AppDelegate)!.thumbnailView!
    let customTransitioningDelegate = InteractiveTransitioningDelegate()
    lazy var videoPlayerViewController: DetailVideoViewController = {
        let vc = AppDefine.kAppDelegate!.videoDetailVC
        vc.modalPresentationStyle = .Custom
        vc.transitioningDelegate = self.customTransitioningDelegate
        vc.handlePan = { (panGestureRecozgnizer) in
            let translatedPoint = panGestureRecozgnizer.translationInView(self.view)
            if panGestureRecozgnizer.state == .Began {
                self.customTransitioningDelegate.beginDismissing(viewController: vc)
                self.lastVideoPlayerOriginY = vc.view.frame.origin.y
            } else if panGestureRecozgnizer.state == .Changed {
                let ratio = max(min(((self.lastVideoPlayerOriginY + translatedPoint.y) / CGRectGetMinY(self.thumbnailVideoContainerView.frame)), 1), 0)
                self.lastPanRatio = ratio
                self.customTransitioningDelegate.updateInteractiveTransition(self.lastPanRatio)
            } else if panGestureRecozgnizer.state == .Ended {
                let completed = (self.lastPanRatio > self.panRatioThreshold) || (self.lastPanRatio < -self.panRatioThreshold)
                self.customTransitioningDelegate.finalizeInteractiveTransition(isTransitionCompleted: completed)
            }
        }
        return vc
    }()

    let panRatioThreshold: CGFloat = 0.3
    var lastPanRatio: CGFloat = 0.0
    var lastVideoPlayerOriginY: CGFloat = 0.0
    var videoPlayerViewControllerInitialFrame: CGRect?

    // MARK:- Draggable Video Progress
    func draggbleProgress(thumbnailVideoContainerView: UIView) {
        customTransitioningDelegate.transitionPresent = { [weak self](fromViewController: UIViewController,
            toViewController: UIViewController, containerView: UIView, transitionType: TransitionType, completion: () -> Void) in
            guard let weakSelf = self else {
                return
            }
            let videoPlayerViewController = toViewController as! DetailVideoViewController
            if case .Simple = transitionType {
                if (weakSelf.videoPlayerViewControllerInitialFrame != nil) {
                    videoPlayerViewController.view.frame = weakSelf.videoPlayerViewControllerInitialFrame!
                    weakSelf.videoPlayerViewControllerInitialFrame = nil
                } else {
                    videoPlayerViewController.view.frame = CGRectOffset(containerView.bounds, 0, CGRectGetHeight(videoPlayerViewController.view.frame))
                    videoPlayerViewController.backgroundView.alpha = 0.0
                    videoPlayerViewController.dismissButton.alpha = 0.0
                }
            }
            UIView.animateWithDuration(defaultTransitionAnimationDuration, animations: {
                videoPlayerViewController.view.transform = CGAffineTransformIdentity
                videoPlayerViewController.view.frame = containerView.bounds
                videoPlayerViewController.backgroundView.alpha = 1.0
                videoPlayerViewController.dismissButton.alpha = 1.0
                videoPlayerViewController.backButton.alpha = 1.0
                videoPlayerViewController.favoriteButton.alpha = 1.0
                videoPlayerViewController.playButton.alpha = 1.0
                videoPlayerViewController.nextButton.alpha = 1.0
                }, completion: { (finished) in
                completion()
                videoPlayerViewController.view.userInteractionEnabled = true
            })
        }
        customTransitioningDelegate.transitionDismiss = { [weak self](fromViewController: UIViewController, toViewController: UIViewController, containerView: UIView, transitionType: TransitionType, completion: () -> Void) in
            guard let weakSelf = self else {
                return
            }
            let videoPlayerViewController = fromViewController as! DetailVideoViewController
            let finalTransform = CGAffineTransformMakeScale(CGRectGetWidth(weakSelf.thumbnailVideoContainerView.bounds) / CGRectGetWidth(videoPlayerViewController.view.bounds), CGRectGetHeight(weakSelf.thumbnailVideoContainerView.bounds) * 3 / CGRectGetHeight(videoPlayerViewController.view.bounds))
            UIView.animateWithDuration(defaultTransitionAnimationDuration, animations: {
                videoPlayerViewController.view.transform = finalTransform
                var finalRect = videoPlayerViewController.view.frame
                finalRect.origin.x = CGRectGetMinX(weakSelf.thumbnailVideoContainerView.frame)
                finalRect.origin.y = CGRectGetMinY(weakSelf.thumbnailVideoContainerView.frame)
                videoPlayerViewController.view.frame = finalRect
                videoPlayerViewController.backgroundView.alpha = 1.0
                videoPlayerViewController.dismissButton.alpha = 0.0
                videoPlayerViewController.backButton.alpha = 0.0
                videoPlayerViewController.favoriteButton.alpha = 0.0
                videoPlayerViewController.playButton.alpha = 0.0
                videoPlayerViewController.nextButton.alpha = 0.0

                videoPlayerViewController
                }, completion: { (finished) in
                completion()
                videoPlayerViewController.view.userInteractionEnabled = false
                weakSelf.parentViewController?.addChildViewController(videoPlayerViewController)
                var thumbnailRect = videoPlayerViewController.view.frame
                thumbnailRect.origin = CGPointZero
                videoPlayerViewController.view.frame = thumbnailRect

                weakSelf.thumbnailVideoContainerView.addSubview(fromViewController.view)
                fromViewController.didMoveToParentViewController(weakSelf.parentViewController)
            })
        }

        customTransitioningDelegate.transitionPercentPresent = { [weak self](fromViewController: UIViewController, toViewController: UIViewController, percentage: CGFloat, containerView: UIView) in
            guard let weakSelf = self else {
                return
            }
            let videoPlayerViewController = toViewController as! DetailVideoViewController
            if (weakSelf.videoPlayerViewControllerInitialFrame != nil) {
                weakSelf.videoPlayerViewController.view.frame = weakSelf.videoPlayerViewControllerInitialFrame!
                weakSelf.videoPlayerViewControllerInitialFrame = nil
            }
            let startXScale = CGRectGetWidth(weakSelf.thumbnailVideoContainerView.bounds) / CGRectGetWidth(containerView.bounds)
            let startYScale = CGRectGetHeight(weakSelf.thumbnailVideoContainerView.bounds) * 3 / CGRectGetHeight(containerView.bounds)
            let xScale = startXScale + ((1 - startXScale) * percentage)
            let yScale = startYScale + ((1 - startYScale) * percentage)
            toViewController.view.transform = CGAffineTransformMakeScale(xScale, yScale)
            let startXPos = CGRectGetMinX(weakSelf.thumbnailVideoContainerView.frame)
            let startYPos = CGRectGetMinY(weakSelf.thumbnailVideoContainerView.frame)
            let horizontalMove = startXPos - (startXPos * percentage)
            let verticalMove = startYPos - (startYPos * percentage)
            var finalRect = toViewController.view.frame
            finalRect.origin.x = horizontalMove
            finalRect.origin.y = verticalMove
            toViewController.view.frame = finalRect
            videoPlayerViewController.backgroundView.alpha = percentage
            videoPlayerViewController.dismissButton.alpha = percentage
        }

        customTransitioningDelegate.transitionPercentDismiss = { [weak self](fromViewController: UIViewController, toViewController: UIViewController, percentage: CGFloat, containerView: UIView) in

            guard let weakSelf = self else {
                return
            }
            let videoPlayerViewController = fromViewController as! DetailVideoViewController
            let finalXScale = CGRectGetWidth(weakSelf.thumbnailVideoContainerView.bounds) / CGRectGetWidth(videoPlayerViewController.view.bounds)
            let finalYScale = CGRectGetHeight(weakSelf.thumbnailVideoContainerView.bounds) * 3 / CGRectGetHeight(videoPlayerViewController.view.bounds)
            let xScale = 1 - (percentage * (1 - finalXScale))
            let yScale = 1 - (percentage * (1 - finalYScale))
            videoPlayerViewController.view.transform = CGAffineTransformMakeScale(xScale, yScale)
            let finalXPos = CGRectGetMinX(weakSelf.thumbnailVideoContainerView.frame)
            let finalYPos = CGRectGetMinY(weakSelf.thumbnailVideoContainerView.frame)
            let horizontalMove = min(CGRectGetMinX(weakSelf.thumbnailVideoContainerView.frame) * percentage, finalXPos)
            let verticalMove = min(CGRectGetMinY(weakSelf.thumbnailVideoContainerView.frame) * percentage, finalYPos)
            var finalRect = videoPlayerViewController.view.frame
            finalRect.origin.x = horizontalMove
            finalRect.origin.y = verticalMove
            videoPlayerViewController.view.frame = finalRect
            videoPlayerViewController.backgroundView.alpha = 1 - percentage
            videoPlayerViewController.dismissButton.alpha = 1 - percentage
        }
    }

}
