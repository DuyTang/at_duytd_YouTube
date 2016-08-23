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
import XCDYouTubeVideoPlayerViewController
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
    private var backButton: UIButton!
    private var favoriteButton: UIButton!
    private var viewPlayer: UIView!
    private var isFavorite = false
    var delegate: DetailVideoDelegete?
    struct Options {
        static let HeightOfRow: CGFloat = 90
        static let MaxRelatedVideo = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Add Video Player View
    func addVideoPlayerView() {
        viewPlayer = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width * 2.3 / 4))
        prepareToPlayVideo()
        playerVideoView.addSubview(viewPlayer)
    }

    func prepareToPlayVideo() {
        youtubeVideoPlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.idVideo)
        youtubeVideoPlayer?.presentInView(viewPlayer)
        youtubeVideoPlayer?.moviePlayer.play()
    }

    // MARK:- Config DetailVideoViewController
    func configureDetailVideoViewController() {
        backButton = UIButton(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        backButton.setImage(UIImage(named: "bt_close"), forState: .Normal)
        backButton.addTarget(self, action: #selector(clickBack), forControlEvents: .TouchUpInside)

        favoriteButton = UIButton(frame: CGRect(x: width - 40, y: 0, width: 40, height: 40))
        setImageForFavoriteButton()
        favoriteButton.addTarget(self, action: #selector(addVideoToFavoriteList), forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
        view.addSubview(favoriteButton)
        detailVideoTable.registerNib(PlayVideoCell)
        detailVideoTable.registerNib(DecriptVideoCell)
        detailVideoTable.registerNib(VideoFavoriteCell)
    }

    func setImageForFavoriteButton() {
        isFavorite = checkFavorite(video.idVideo)
        let nameImage = isFavorite ? "bt_starfill" : "bt_star"
        favoriteButton.setImage(UIImage(named: nameImage), forState: .Normal)
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        addVideoPlayerView()
        configureDetailVideoViewController()
    }

    // MARK:- Set Up Data
    override func setUpData() {
        videos.removeAll()
        loadData()
    }

    // MARK:- Load related video
    private func loadData() {

        loadRelatedVideo(video.idVideo)
    }

    private func loadRelatedVideo(id: String) {
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["maxResults"] = Options.MaxRelatedVideo
        parameters["relatedToVideoId"] = id
        parameters["type"] = "video"
        showLoading()
        MyVideo.loadListVideoRelated(parameters) { (response) in
            if let items = response as? NSArray {
                for item in items {
                    let video = Mapper<Video>().map(item)
                    var parameter = [String: AnyObject]()
                    parameter["part"] = "contentDetails,statistics"
                    parameter["id"] = video?.idVideo
                    MyVideo.loadDetailVideoFromIdVideo(parameter, completion: { (response) in
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
            presentViewController(addFavoriteVC, animated: false, completion: nil)
            isFavorite = true
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

    @IBAction func clickBack(sender: AnyObject) {
        youtubeVideoPlayer?.moviePlayer.stop()
        navigationController?.popViewControllerAnimated(true)
    }
}
// MARK:- Extension
extension DetailVideoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count + 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = detailVideoTable.dequeue(PlayVideoCell.self)
            cell.delegate = self
            cell.configPlayVideoCell(video)
            return cell
        } else {
            if indexPath.row == 1 {
                let cell = detailVideoTable.dequeue(DecriptVideoCell.self)
                cell.configureDecriptVideoCell(video)
                return cell
            } else {
                let cell = detailVideoTable.dequeue(VideoFavoriteCell.self)
                let video = videos[indexPath.row - 2]
                cell.configureCell(video)
                return cell
            }
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else {
            if indexPath.row == 1 {
                return !isExpandDescription ? 0 : UITableViewAutomaticDimension
            } else {
                return Options.HeightOfRow
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 1 {
            if videos.count > 0 {
                video = videos[indexPath.row - 2]
                loadData()
                isFavorite = false
                favoriteButton.setImage(UIImage(named: "bt_star"), forState: .Normal)
                prepareToPlayVideo()
                History.addVideoToHistory(video)
            }

        }
    }
}

extension DetailVideoViewController: AddFavoriteDelegate {
    func addSuccess(isSuccess: Bool) {
        if isSuccess {
            favoriteButton.setImage(UIImage(named: "bt_starfill"), forState: .Normal)
        } else {
            isFavorite = isSuccess
        }
    }
}

extension DetailVideoViewController: PlayVideoCellDelegate {
    func clickExpandDescription(cell: PlayVideoCell) {
        isExpandDescription = !isExpandDescription
        detailVideoTable.beginUpdates()
        detailVideoTable.endUpdates()
    }
}
