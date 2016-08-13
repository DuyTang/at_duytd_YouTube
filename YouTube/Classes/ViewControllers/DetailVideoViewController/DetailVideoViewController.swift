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
    @IBOutlet weak private var favoriteButton: UIButton!
    var video = Video()
    @IBOutlet weak private var detailVideoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.detailVideoTable.dequeue(PlayVideoCell.self)
            cell.configPlayVideoCell(video)
            return cell
        } else {
            if indexPath.row == 1 {
                let cell = self.detailVideoTable.dequeue(DecriptVideoCell.self)
                cell.decriptVideoLabel.text = "Decription"
                cell.detailDecriptVideoLabel.text = video.descript
                return cell
            } else {
                let cell = self.detailVideoTable.dequeue(HomeCell.self)
                return cell
            }
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row > 1 {
            return 100
        } else {
            return UITableViewAutomaticDimension
        }
    }
}
extension DetailVideoViewController: AddFavoriteDelegate {
    func addSuccess(isSuccess: Bool) {
        if isSuccess == true {
            self.favoriteButton.setImage(UIImage(named: "bt_starfill"), forState: .Normal)
        }
    }
}
