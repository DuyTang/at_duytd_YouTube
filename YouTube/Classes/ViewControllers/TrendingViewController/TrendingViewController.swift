//
//  TrendingViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/16/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class TrendingViewController: BaseViewController {
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var thumbnailVideoContainerView: UIView!
    private var trendingVideos: Results<Video>!
    private var idCategory = "0"
    private var nextPage: String?
    private var isLoading = false
    private var loadmoreActive = true
    private var isPlaying = false
    private struct Options {
        static let HeightOfRow: CGFloat = 205
    }
    let customTransitioningDelegate: InteractiveTransitioningDelegate = InteractiveTransitioningDelegate()
    lazy var videoPlayerViewController: DetailVideoViewController = {
        let vc = DetailVideoViewController()
        vc.modalPresentationStyle = .Custom
        vc.transitioningDelegate = self.customTransitioningDelegate
        vc.handlePan = { (panGestureRecozgnizer) in
            let translatedPoint = panGestureRecozgnizer.translationInView(self.view)
            if (panGestureRecozgnizer.state == .Began) {
                self.customTransitioningDelegate.beginDismissing(viewController: vc)
                self.lastVideoPlayerOriginY = vc.view.frame.origin.y
            } else if (panGestureRecozgnizer.state == .Changed) {
                let ratio = max(min(((self.lastVideoPlayerOriginY + translatedPoint.y) / CGRectGetMinY(self.thumbnailVideoContainerView.frame)), 1), 0)
                self.lastPanRatio = ratio
                self.customTransitioningDelegate.updateInteractiveTransition(self.lastPanRatio)
            } else if (panGestureRecozgnizer.state == .Ended) {
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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
                self!.showButtonInPlayVideoView(1.0)
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
                self!.showButtonInPlayVideoView(0.0)
                videoPlayerViewController
                }, completion: { (finished) in
                completion()
                videoPlayerViewController.view.userInteractionEnabled = false
                weakSelf.addChildViewController(videoPlayerViewController)
                var thumbnailRect = videoPlayerViewController.view.frame
                thumbnailRect.origin = CGPointZero
                videoPlayerViewController.view.frame = thumbnailRect

                weakSelf.thumbnailVideoContainerView.addSubview(fromViewController.view)
                fromViewController.didMoveToParentViewController(weakSelf)
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

    // MARK:- Show Hide Button In PlayVideoView
    func showButtonInPlayVideoView(alpha: CGFloat) {
        videoPlayerViewController.backgroundView.alpha = 1.0
        videoPlayerViewController.dismissButton.alpha = alpha
        videoPlayerViewController.backButton.alpha = alpha
        videoPlayerViewController.favoriteButton.alpha = alpha
        videoPlayerViewController.playButton.alpha = alpha
        videoPlayerViewController.nextButton.alpha = alpha
    }

    // MARk:- Set up UI
    override func setUpUI() {
        trendingTableView.registerNib(HomeCell)
        draggbleProgress(thumbnailVideoContainerView)
    }

    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
        if let videos = Video.getVideos(idCategory) where videos.count > 0 {
            trendingVideos = videos
        } else {
            loadTrendingVideo(idCategory, pageToken: nil)
        }
    }

    // MARK:- Load Data
    func loadData() {
        do {
            let realm = try Realm()
            trendingVideos = realm.objects(Video).filter("idCategory = %@", idCategory)
            trendingTableView.reloadData()
        } catch {

        }
    }

    func loadTrendingVideo(id: String, pageToken: String?) {

        if isLoading {
            return
        }
        isLoading = true
        showLoading()
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet,contentDetails,statistics"
        parameters["chart"] = "mostPopular"
        parameters["regionCode"] = "VN"
        parameters["maxResults"] = "10"
        parameters["pageToken"] = nextPage
        VideoService.loadDataFromAPI(idCategory, parameters: parameters) { (success, nextPageToken, error) in
            if success {
                self.hideLoading()
                self.trendingTableView.reloadData()
                self.nextPage = nextPageToken
                if nextPageToken == nil {
                    self.loadmoreActive = false
                }
            } else {
                self.showAlert(Message.Title, message: Message.LoadDataFail, cancelButton: Message.OkButton)
            }
            self.isLoading = false
        }
    }
    // MARK:- Draggable Video Progress
    @IBAction func presentFromThumbnailAction(sender: UITapGestureRecognizer) {
        guard self.videoPlayerViewController.parentViewController != nil else {
            return
        }
        videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: view)
        videoPlayerViewController.removeFromParentViewController()
        presentViewController(videoPlayerViewController, animated: true, completion: nil)
    }

    @IBAction func handlePresentPan(panGestureRecozgnizer: UIPanGestureRecognizer) {
        guard videoPlayerViewController.parentViewController != nil || customTransitioningDelegate.isPresenting else {
            return
        }
        let translatedPoint = panGestureRecozgnizer.translationInView(self.view)
        if (panGestureRecozgnizer.state == .Began) {
            videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: view)
            videoPlayerViewController.removeFromParentViewController()
            customTransitioningDelegate.beginPresenting(viewController: videoPlayerViewController, fromViewController: self)
            videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: view)
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

}

extension TrendingViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = trendingVideos {
            return videos.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = trendingTableView.dequeue(HomeCell.self)
        let video = trendingVideos[indexPath.row]
        cell.configureCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if videoPlayerViewController.parentViewController != nil {
            videoPlayerViewControllerInitialFrame = thumbnailVideoContainerView.convertRect(videoPlayerViewController.view.frame, toView: view)
            videoPlayerViewController.removeFromParentViewController()
        }
        videoPlayerViewController.video = trendingVideos![indexPath.row]
        History.addVideoToHistory(trendingVideos![indexPath.row])
        view.removeFromSuperview()
        self.tabBarController?.presentViewController(videoPlayerViewController, animated: true, completion: nil)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && loadmoreActive {
            loadTrendingVideo(idCategory, pageToken: nextPage)
        }
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}
