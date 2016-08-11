//
//  DetailVideoViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class DetailVideoViewController: BaseViewController {

    @IBOutlet weak private var playVideoView: YTPlayerView!
    @IBOutlet weak private var favoriteButton: UIButton!
    @IBOutlet weak private var nameVideoLabel: UILabel!
    @IBOutlet weak private var nameChannelLabel: UILabel!
    @IBOutlet weak private var thumbnailVideo: UIImageView!
    @IBOutlet weak private var viewCountLabel: UILabel!
    var video = Video()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playVideoView.loadWithVideoId(video.idVideo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Config DetailVideoViewController
    func configureDetailVideoViewController() {
        self.favoriteButton.hidden = video.isFavorite
        self.nameVideoLabel.text = video.title
        self.nameChannelLabel.text = video.channelTitle
        self.thumbnailVideo.downloadImage(video.thumbnail)
        self.viewCountLabel.text = "\(video.viewCount) views"
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        configureDetailVideoViewController()
    }
    // MARK:- Set Up Data
    override func setUpData() {

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
