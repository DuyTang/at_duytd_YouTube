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
    var idVideo = ""
    var isFavorite = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playVideoView.loadWithVideoId(idVideo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Config DetailVideoViewController
    func configureDetailVideoViewController() {
        self.favoriteButton.hidden = isFavorite
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
        presentViewController(addFavoriteVC, animated: false, completion: nil)
    }
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
