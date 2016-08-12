//
//  DetailVideoViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class DetailVideoViewController: BaseViewController {

    // @IBOutlet weak private var playVideoView: YTPlayerView!
    @IBOutlet weak private var favoriteButton: UIButton!
    // @IBOutlet weak private var nameVideoLabel: UILabel!
    // @IBOutlet weak private var nameChannelLabel: UILabel!
    // @IBOutlet weak private var thumbnailVideo: UIImageView!
    var video = Video()
    @IBOutlet weak private var detailVideoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.playVideoView.loadWithVideoId(video.idVideo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Config DetailVideoViewController
    func configureDetailVideoViewController() {
        // self.favoriteButton.hidden = video.isFavorite
        if video.isFavorite == true || checkFavorite(video.idVideo) == true {
            self.favoriteButton.setImage(UIImage(named: AppDefine.ImageSelectedButton), forState: .Normal)
            self.favoriteButton.enabled = false
        } else {
            self.favoriteButton.setImage(UIImage(named: AppDefine.ImageButton), forState: .Normal)
            self.favoriteButton.enabled = true
        }
        // self.nameVideoLabel.text = video.title

        self.detailVideoTable.registerNib(PlayVideoCell)
        self.detailVideoTable.registerNib(DecriptVideoCell)
        self.detailVideoTable.registerNib(HomeCell)
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        configureDetailVideoViewController()
        // UIView.setBorder(self.subscribeButton, cornerRadius: 5.0, borderWidth: 1.0, borderColor: AppDefine.backgroundColor)
    }
    // MARK:- Set Up Data
    override func setUpData() {

    }
    private func checkFavorite(idVideo: String) -> Bool {
        var isFavorite = false
        do {
            let realm = try Realm()
            let listVideo = realm.objects(ListVideoFavorite).filter("idVideo = %@", video.idVideo)
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
        presentViewController(addFavoriteVC, animated: false, completion: nil)
    }
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension DetailVideoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.detailVideoTable.dequeue(PlayVideoCell.self)
            cell.nameVideoLabel.text = video.title
            cell.channelLabel.text = video.channelTitle
            cell.thumbnailVideo.downloadImage(video.thumbnail)
            cell.viewCountLabel.text = "\(video.viewCount) views"
            cell.playVideoView.loadWithVideoId(video.idVideo)
            return cell
        } else {
            if indexPath.row == 1 {
                let cell = self.detailVideoTable.dequeue(DecriptVideoCell.self)
                cell.decriptVideoLabel.text = "Decription"
                cell.detailDecriptVideoLabel.text = video.descript
                return cell
            } else {
                if indexPath.row == 2 {
                    let cell = self.detailVideoTable.dequeue(DecriptVideoCell.self)
                    cell.decriptVideoLabel.text = "Related Video"
                    cell.detailDecriptVideoLabel.hidden = true
                    return cell
                } else {
                    let cell = self.detailVideoTable.dequeue(HomeCell.self)
                    return cell
                }
            }
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
