//
//  DraggableVideo.swift
//  YouTube
//
//  Created by Duy Tang on 9/5/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
class DraggalbeVideo {
    private var thumbnailVideoContainerView: UIView = (UIApplication.sharedApplication().delegate as? AppDelegate)!.thumbnailView!
    private let customTransitioningDelegate = InteractiveTransitioningDelegate()
    private var parentVC: UIViewController!
    lazy var videoPlayerViewController: DetailVideoViewController = {
        let vc = AppDefine.kAppDelegate!.videoDetailVC
        vc.modalPresentationStyle = .Custom
        vc.transitioningDelegate = self.customTransitioningDelegate
        vc.handlePan = { (panGestureRecozgnizer) in
            let translatedPoint = panGestureRecozgnizer.translationInView(self.parentVC.view)
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

    private let panRatioThreshold: CGFloat = 0.3
    private var lastPanRatio: CGFloat = 0.0
    private var lastVideoPlayerOriginY: CGFloat = 0.0
    private var videoPlayerViewControllerInitialFrame: CGRect?

    init(rootViewController: UIViewController) {
        self.parentVC = rootViewController
    }

    func draggbleProgress() {
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
                    videoPlayerViewController.view.frame = CGRectOffset(containerView.bounds, 0,
                        CGRectGetHeight(videoPlayerViewController.view.frame))
                    videoPlayerViewController.backgroundView.alpha = 0.0
                }
            }
            UIView.animateWithDuration(defaultTransitionAnimationDuration, animations: {
                videoPlayerViewController.view.transform = CGAffineTransformIdentity
                videoPlayerViewController.view.frame = containerView.bounds
                videoPlayerViewController.showButton(1.0)
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
                videoPlayerViewController.view.frame = CGRect(origin: finalRect.origin, size: CGSizeMake(weakSelf.thumbnailVideoContainerView.bounds.width, weakSelf.thumbnailVideoContainerView.bounds.height))
                videoPlayerViewController.showButton(0.0)

                }, completion: { (finished) in
                completion()
                videoPlayerViewController.view.userInteractionEnabled = false
                weakSelf.parentVC?.addChildViewController(videoPlayerViewController)
                var thumbnailRect = videoPlayerViewController.view.frame
                thumbnailRect.origin = CGPointZero
                videoPlayerViewController.view.frame = thumbnailRect

                weakSelf.thumbnailVideoContainerView.addSubview(fromViewController.view)
                fromViewController.didMoveToParentViewController(weakSelf.parentVC)
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
        }
    }

    func addActionToView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentFromThumbnailAction))
        thumbnailVideoContainerView.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePresentPan))
        thumbnailVideoContainerView.addGestureRecognizer(pan)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exitPLayerVideo))
        thumbnailVideoContainerView.addGestureRecognizer(longPress)

    }

    @objc private func presentFromThumbnailAction(sender: UITapGestureRecognizer? = nil) {
        guard self.videoPlayerViewController.parentViewController != nil else {
            return
        }
        videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: parentVC!.view)
        videoPlayerViewController.removeFromParentViewController()
        parentVC.presentViewController(videoPlayerViewController, animated: true, completion: nil)
    }

    @objc private func handlePresentPan(panGestureRecozgnizer: UIPanGestureRecognizer) {
        guard videoPlayerViewController.parentViewController != nil || customTransitioningDelegate.isPresenting else {
            return
        }
        let translatedPoint = panGestureRecozgnizer.translationInView(parentVC.view)
        if (panGestureRecozgnizer.state == .Began) {
            videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: parentVC.view)
            videoPlayerViewController.removeFromParentViewController()
            customTransitioningDelegate.beginPresenting(viewController: videoPlayerViewController, fromViewController: parentVC)
            videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: parentVC.view)
            lastVideoPlayerOriginY = videoPlayerViewControllerInitialFrame!.origin.y

        } else if (panGestureRecozgnizer.state == .Changed) {
            let ratio = max(min(((lastVideoPlayerOriginY + translatedPoint.y) / CGRectGetMinY(thumbnailVideoContainerView.frame)), 1), 0)
            lastPanRatio = 1 - ratio
            customTransitioningDelegate.updateInteractiveTransition(lastPanRatio)

        } else if (panGestureRecozgnizer.state == .Ended) {
            let completed = lastPanRatio > panRatioThreshold || lastPanRatio < -panRatioThreshold
            customTransitioningDelegate.finalizeInteractiveTransition(isTransitionCompleted: completed)
        }
    }

    @objc private func exitPLayerVideo(swipeGesture: UISwipeGestureRecognizer) {
        let alert = UIAlertController(title: Message.Title, message: "Would you like to exit play video", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Message.OkButton, style: .Default, handler: { action in
            self.videoPlayerViewController.youtubeVideoPlayer?.moviePlayer.pause()
            self.videoPlayerViewController.view.removeFromSuperview()
            self.videoPlayerViewController.removeFromParentViewController()
            }))
        alert.addAction(UIAlertAction(title: Message.CancelButton, style: UIAlertActionStyle.Cancel, handler: { action in

            }))
        parentVC.presentViewController(alert, animated: true, completion: nil)
    }

    func prensetDetailVideoController(video: Video) {
        if videoPlayerViewController.parentViewController != nil {
            videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(self.videoPlayerViewController.view.frame, toView: parentVC.view)
            self.videoPlayerViewController.removeFromParentViewController()
        }
        videoPlayerViewController.video = video
        videoPlayerViewController.oldVideo = video
        videoPlayerViewController.loadData()
        videoPlayerViewController.prepareToPlayVideo(video.idVideo)
        videoPlayerViewController.checkFavorite(video.idVideo)
        videoPlayerViewController.setImageForFavoriteButton()
        History.addVideoToHistory(video)
        parentVC.presentViewController(videoPlayerViewController, animated: true, completion: nil)
    }

}
