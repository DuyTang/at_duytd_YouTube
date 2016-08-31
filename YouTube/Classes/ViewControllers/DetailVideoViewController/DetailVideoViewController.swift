//
//  DetailVideoViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import XCDYouTubeKit
import SwiftUtils
protocol DetailVideoDelegete {
    func deleteFromListFavorite(isDeleted: Bool)
}

class DetailVideoViewController: BaseViewController {
    @IBOutlet weak private var detailVideoTable: UITableView!
    @IBOutlet weak private var playerVideoView: UIView!
    private var dataOfRelatedVideo: Results<RelatedVideo>!
    private var youtubeVideoPlayer: XCDYouTubeVideoPlayerViewController?
    private var isExpandDescription = false
    private var width = UIScreen.mainScreen().bounds.width
    var video = Video()
    private var videos = [Video]()
    var backButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    var favoriteButton: UIButton!
    private var viewPlayer: UIView!
    private var isFavorite = false
    var playButton: UIButton!
    var nextButton: UIButton!
    var delegate: DetailVideoDelegete?
    private struct Options {
        static let HeightOfRow: CGFloat = 90
        static let HeightOfPlayVideoCell: CGFloat = 108
        static let HeightOfButtonCell: CGFloat = 38
        static let MaxRelatedVideo = 20
    }
    @IBOutlet weak var backgroundView: UIView!
    var handlePan: ((panGestureRecognizer: UIPanGestureRecognizer) -> Void)?
    var isPlaying = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func setUp() {
        modalPresentationStyle = .OverCurrentContext
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    // MARK:- Add Video Player View
    func addVideoPlayerView() {
        viewPlayer = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width * 2.3 / 4))
        prepareToPlayVideo(video.idVideo)
        playerVideoView.addSubview(viewPlayer)
    }

    func prepareToPlayVideo(id: String) {
        youtubeVideoPlayer?.view.removeFromSuperview()
        youtubeVideoPlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: id)
        youtubeVideoPlayer?.presentInView(viewPlayer)
        youtubeVideoPlayer?.moviePlayer.play()
        isPlaying = true
    }

    // MARK:- Config DetailVideoViewController
    func configureDetailVideoViewController() {
        backButton = UIButton(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        backButton.setImage(UIImage(named: "bt_close"), forState: .Normal)
        backButton.addTarget(self, action: #selector(hideView), forControlEvents: .TouchUpInside)

        favoriteButton = UIButton(frame: CGRect(x: width - 40, y: 0, width: 40, height: 40))
        setImageForFavoriteButton()
        favoriteButton.addTarget(self, action: #selector(addVideoToFavoriteList), forControlEvents: .TouchUpInside)

        playButton = UIButton(frame: CGRect(x: viewPlayer.frame.midX - 25, y: viewPlayer.frame.midY - 25, width: 50, height: 50))
        playButton.setImage(UIImage(named: "bt_pause"), forState: .Normal)
        playButton.tintColor = .whiteColor()
        playButton.addTarget(self, action: #selector(handlePause), forControlEvents: .TouchUpInside)

        nextButton = UIButton(frame: CGRect(x: viewPlayer.frame.midX + 20, y: viewPlayer.frame.midY - 25, width: 50, height: 50))
        nextButton.setImage(UIImage(named: "bt_next"), forState: .Normal)
        nextButton.addTarget(self, action: #selector(handleNext), forControlEvents: .TouchUpInside)

        view.addSubview(backButton)
        view.addSubview(favoriteButton)
        view.addSubview(playButton)
        view.addSubview(nextButton)
        detailVideoTable.registerNib(PlayVideoCell)
        detailVideoTable.registerNib(DecriptVideoCell)
        detailVideoTable.registerNib(ButtonCell)
        detailVideoTable.registerNib(VideoFavoriteCell)
    }

    func setImageForFavoriteButton() {
        isFavorite = checkFavorite(video.idVideo)
        let nameImage = isFavorite ? "bt_starfill" : "bt_star"
        favoriteButton.setImage(UIImage(named: nameImage), forState: .Normal)
    }

    func handlePause() {
        if isPlaying {
            youtubeVideoPlayer?.moviePlayer.pause()
            playButton.setImage(UIImage(named: "bt_play"), forState: .Normal)
        } else {
            youtubeVideoPlayer?.moviePlayer.play()
            playButton.setImage(UIImage(named: "bt_pause"), forState: .Normal)
        }
        isPlaying = !isPlaying
    }

    func handleNext() {
        isFavorite = false
        video = videos[0]
        loadData()
        favoriteButton.setImage(UIImage(named: "bt_star"), forState: .Normal)
        prepareToPlayVideo(video.idVideo)
        History.addVideoToHistory(video)
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        addVideoPlayerView()
        configureDetailVideoViewController()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeVideo(_:)), name: XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification, object: nil)
        addNotifiation()
    }
    func changeVideo(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            self.youtubeVideoPlayer!.moviePlayer.prepareToPlay()
        }
    }

    // MARK:- Set Up Data
    override func setUpData() {
        videos.removeAll()
        loadData()
    }

    // MARK:- Load related video
    func loadData() {
        videos.removeAll()
        loadRelatedVideo(video.idVideo)
    }

    private func addNotifiation() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moviePlayerNowPlayingMovieDidChange),
            name: MPMoviePlayerNowPlayingMovieDidChangeNotification, object: youtubeVideoPlayer?.moviePlayer)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moviePlayerLoadStateDidChange),
            name: MPMoviePlayerLoadStateDidChangeNotification, object: youtubeVideoPlayer?.moviePlayer)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moviePlayerPlaybackDidChange),
            name: MPMoviePlayerPlaybackStateDidChangeNotification, object: youtubeVideoPlayer?.moviePlayer)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moviePlayerPlayBackDidFinish),
            name: MPMoviePlayerPlaybackDidFinishNotification, object: youtubeVideoPlayer?.moviePlayer)
    }

    func moviePlayerPlayBackDidFinish(notification: NSNotification) {
        dismissViewControllerAnimated(true, completion: nil);
        youtubeVideoPlayer?.view.removeFromSuperview()
        prepareToPlayVideo(videos[0].idVideo)
    }

    func moviePlayerNowPlayingMovieDidChange(notification: NSNotification) {
    }

    func moviePlayerLoadStateDidChange(notification: NSNotification) {
        let state = (youtubeVideoPlayer?.moviePlayer.playbackState)!
        switch state {
        case .Stopped:
            // playNextVideo(videos[0].idVideo)
            break
        case .Interrupted:
            break
        case .SeekingForward:
            break
        case .SeekingBackward:
            break
        case .Paused:
            break
        case .Playing:
            break
        }
    }

    func moviePlayerPlaybackDidChange(notification: NSNotification) {
        let state = (youtubeVideoPlayer?.moviePlayer.playbackState)!
        switch state {
        case .Stopped:
            playNextVideo(videos[0].idVideo)
            break
        case .Interrupted:
            break
        case .SeekingForward:
            break
        case .SeekingBackward:
            break
        case .Paused:
            break
        case .Playing:
            break
        }
    }

    func playNextVideo(id: String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification,
            object: youtubeVideoPlayer?.moviePlayer)
        youtubeVideoPlayer?.videoIdentifier = id
        youtubeVideoPlayer?.moviePlayer.prepareToPlay()
        youtubeVideoPlayer?.moviePlayer.play()
    }

    private func loadRelatedVideo(id: String) {
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["maxResults"] = Options.MaxRelatedVideo
        parameters["relatedToVideoId"] = id
        parameters["type"] = "video"
        showLoading()
        VideoService.loadListVideoRelated(parameters) { (response) in
            if let items = response as? NSArray {
                for item in items {
                    let video = Mapper<Video>().map(item)
                    var parameter = [String: AnyObject]()
                    parameter["part"] = "contentDetails,statistics"
                    parameter["id"] = video?.idVideo
                    VideoService.loadDetailVideoFromIdVideo(parameter, completion: { (response) in
                        if let detailVideo = response as? NSArray {
                            for item in detailVideo {
                                if let detailVideo = item.objectForKey("contentDetails") as? NSDictionary {
                                    video?.duration = detailVideo["duration"] as? String ?? ""
                                }
                                if let statistics = item.objectForKey("statistics") as? NSDictionary {
                                    video?.viewCount = statistics["viewCount"] as? String ?? ""
                                }
                                self.videos.append(video!)
                                self.detailVideoTable.reloadData()
                            }
                        }
                    })
                }
                self.hideLoading()
            }
        }
    }

    // MARK:- Check Favorite
    private func checkFavorite(idVideo: String) -> Bool {
        var isFavorite = false
        do {
            let realm = try Realm()
            let listVideo = realm.objects(VideoFavorite).filter("idVideo = %@", video.idVideo)
            if listVideo.count > 0 {
                isFavorite = true
            }
        } catch {
        }
        return isFavorite
    }

    // MARK:- Action
    @IBAction func addVideoToFavoriteList(sender: AnyObject) {
        self.youtubeVideoPlayer?.moviePlayer.pause()
        if isFavorite == false {
            let addFavoriteVC = AddFavoriteViewController()
            addFavoriteVC.video = video
            addFavoriteVC.delegate = self
            addFavoriteVC.view.frame = view.bounds
            view.addSubview(addFavoriteVC.view)
            self.addChildViewController(addFavoriteVC)

        } else {
            do {
                let realm = try Realm()
                let video = realm.objects(VideoFavorite).filter("idVideo = %@", self.video.idVideo).first
                try realm.write({
                    realm.delete(video!)
                })
            } catch {

            }
            favoriteButton.setImage(UIImage(named: "bt_star"), forState: .Normal)
            isFavorite = false
            delegate?.deleteFromListFavorite(isFavorite)
        }
    }

    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        self.handlePan?(panGestureRecognizer: sender)
    }
    @IBAction func hideView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
// MARK:- Extension
extension DetailVideoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count + 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = detailVideoTable.dequeue(PlayVideoCell.self)
            cell.configPlayVideoCell(video)
            return cell
        } else {
            if indexPath.row == 1 {
                let cell = detailVideoTable.dequeue(DecriptVideoCell.self)
                cell.configureDecriptVideoCell(video)
                return cell
            } else {
                if indexPath.row == 2 {
                    let cell = detailVideoTable.dequeue(ButtonCell.self)
                    cell.delegate = self
                    return cell
                } else {
                    let cell = detailVideoTable.dequeue(VideoFavoriteCell.self)
                    let video = videos[indexPath.row - 3]
                    cell.configureCell(video)
                    return cell
                }
            }
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Options.HeightOfPlayVideoCell
        } else {
            if indexPath.row == 1 {
                return !isExpandDescription ? 20 : UITableViewAutomaticDimension
            } else {
                if indexPath.row == 2 {
                    return Options.HeightOfButtonCell
                } else {
                    return Options.HeightOfRow
                }
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 1 {
            if videos.count > 0 {
                video = videos[indexPath.row - 3]
                loadData()
                isFavorite = false
                favoriteButton.setImage(UIImage(named: "bt_star"), forState: .Normal)
                prepareToPlayVideo(video.idVideo)
                History.addVideoToHistory(video)
            }

        }
    }
}

extension DetailVideoViewController: AddFavoriteDelegate {
    func addSuccess(isSuccess: Bool) {
        if isSuccess {
            favoriteButton.setImage(UIImage(named: "bt_starfill"), forState: .Normal)
            isFavorite = isSuccess
        } else {
            isFavorite = isSuccess
        }

    }
}

extension DetailVideoViewController: ButtonCellDelegate {
    func clickExpandDescription(cell: ButtonCell) {
        isExpandDescription = !isExpandDescription
        detailVideoTable.beginUpdates()
        detailVideoTable.endUpdates()
    }
}
