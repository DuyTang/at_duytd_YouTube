//
//  DetailVideoViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import XCDYouTubeVideoPlayerViewController

class DetailVideoViewController: BaseViewController {
    @IBOutlet weak private var favoriteButton: UIButton!
    var video = Video()
    @IBOutlet weak private var detailVideoTable: UITableView!
    @IBOutlet weak private var playerVideoView: YTPlayerView!
    private var dataOfRelatedVideo: Results<RelatedVideo>!
    var pageToken: String?
    private var youtubeVideoPlayer: XCDYouTubeVideoPlayerViewController?
    private var isExpandDescription = false
    private var width = UIScreen.mainScreen().bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeVideoPlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.idVideo)
        let viewPlayer = UIView(frame: CGRect(x: 0, y: 64, width: self.width, height: 180))
        self.youtubeVideoPlayer?.presentInView(viewPlayer)
        self.youtubeVideoPlayer?.preferredVideoQualities
        youtubeVideoPlayer?.moviePlayer.play()
        self.view.addSubview(viewPlayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Config DetailVideoViewController
    func configureDetailVideoViewController() {
        if checkFavorite(video.idVideo) == true {
            self.favoriteButton.setImage(UIImage(named: "bt_starfill"), forState: .Normal)
            self.favoriteButton.enabled = false
        } else {
            self.favoriteButton.setImage(UIImage(named: "bt_star"), forState: .Normal)
            self.favoriteButton.enabled = true
        }
        self.detailVideoTable.registerNib(PlayVideoCell)
        self.detailVideoTable.registerNib(DecriptVideoCell)
        self.detailVideoTable.registerNib(HomeCell)
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        configureDetailVideoViewController()
    }

    // MARK:- Set Up Data
    override func setUpData() {
        RelatedVideo.cleanData()
        if let relatedVideo = RelatedVideo.getRelatedVideo() where relatedVideo.count > 0 {
            dataOfRelatedVideo = relatedVideo
            loadData()
        } else {
            loadRelatedVideo(video.idVideo, pageToken: pageToken)
        }
    }

    // MARK:- Load related video
    private func loadData() {
        do {
            let realm = try Realm()
            dataOfRelatedVideo = realm.objects(RelatedVideo)
            self.detailVideoTable.reloadData()
        } catch {

        }

    }

    private func loadRelatedVideo(id: String, pageToken: String?) {
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["maxResults"] = "10"
        parameters["relatedToVideoId"] = video.idVideo
        parameters["type"] = "video"
        parameters["pageToken"] = pageToken
        MyVideo.loadListVideoRelated(pageToken, parameters: parameters) { (success, nextPageToken, error) in
            if success {
                self.loadData()
                self.pageToken = nextPageToken
            } else {
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
        let addFavoriteVC = AddFavoriteViewController()
        addFavoriteVC.idVideo = video.idVideo
        addFavoriteVC.delegate = self
        presentViewController(addFavoriteVC, animated: false, completion: nil)
    }

    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
// MARK:- Extension
extension DetailVideoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = dataOfRelatedVideo {
            let numberRow = videos.count + 2
            return numberRow
        } else {
            return 2
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.detailVideoTable.dequeue(PlayVideoCell.self)
            cell.delegate = self
            cell.configPlayVideoCell(video)
            return cell
        } else {
            if indexPath.row == 1 {
                let cell = self.detailVideoTable.dequeue(DecriptVideoCell.self)
                cell.detailDecriptVideoLabel.text = video.descript
                return cell
            } else {
                let cell = self.detailVideoTable.dequeue(HomeCell.self)
                let video = Video()
                video.initFromRelatedVideo(dataOfRelatedVideo[indexPath.row - 2])
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
                return !isExpandDescription ? 70 : UITableViewAutomaticDimension
            } else {
                return 216
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVideo = Video()
        newVideo.initFromRelatedVideo(dataOfRelatedVideo[indexPath.row - 2])
        self.video = newVideo
        self.loadData()
    }
}

extension DetailVideoViewController: AddFavoriteDelegate {
    func addSuccess(isSuccess: Bool) {
        if isSuccess == true {
            self.favoriteButton.setImage(UIImage(named: "bt_starfill"), forState: .Normal)
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
