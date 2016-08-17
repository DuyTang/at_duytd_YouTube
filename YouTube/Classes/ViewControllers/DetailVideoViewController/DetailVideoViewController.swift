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

class DetailVideoViewController: BaseViewController {
    @IBOutlet weak private var favoriteButton: UIButton!
    @IBOutlet weak private var detailVideoTable: UITableView!
    @IBOutlet weak private var playerVideoView: UIView!
    private var dataOfRelatedVideo: Results<RelatedVideo>!
    private var youtubeVideoPlayer: XCDYouTubeVideoPlayerViewController?
    private var isExpandDescription = false
    private var width = UIScreen.mainScreen().bounds.width
    var video = Video()
    private var videos = [Video]()

    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeVideoPlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.idVideo)
        let viewPlayer = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width * 2.3 / 4))
        self.youtubeVideoPlayer?.presentInView(viewPlayer)
        self.youtubeVideoPlayer?.preferredVideoQualities
        youtubeVideoPlayer?.moviePlayer.play()
        self.playerVideoView.addSubview(viewPlayer)
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
        self.detailVideoTable.registerNib(VideoFavoriteCell)
    }
    override func setUp() {

    }

    // MARK:- Set Up UI
    override func setUpUI() {

        configureDetailVideoViewController()
    }

    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }

    // MARK:- Load related video
    private func loadData() {
        loadRelatedVideo(video.idVideo)
    }

    private func loadRelatedVideo(id: String) {
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["maxResults"] = "2"
        parameters["relatedToVideoId"] = id
        parameters["type"] = "video"
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
        return videos.count + 2
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
                cell.configureDecriptVideoCell(video)
                return cell
            } else {
                let cell = self.detailVideoTable.dequeue(VideoFavoriteCell.self)
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
                return AppDefine.heightOfNomarlCell
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

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
