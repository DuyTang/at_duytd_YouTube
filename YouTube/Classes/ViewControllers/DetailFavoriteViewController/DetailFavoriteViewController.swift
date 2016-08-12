//
//  DetailFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

class DetailFavoriteViewController: BaseViewController {

    @IBOutlet weak private var nameListFavoriteLabel: UILabel!
    @IBOutlet weak private var listVideoFavoriteTableView: UITableView!
    var favorite = Favorite()
    var listVideo: Results<ListVideoFavorite>?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func configureDetailFavoriteViewController() {
        self.listVideoFavoriteTableView.registerNib(VideoFavoriteCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.configureDetailFavoriteViewController()
        self.nameListFavoriteLabel.text = favorite.name
    }
    // MARK:- Set Up Data
    override func setUpData() {
        self.loadData()
    }
    private func loadData() {
        do {
            let realm = try Realm()
            listVideo = realm.objects(ListVideoFavorite).filter("idListFavorite = '\(favorite.id)'")
        } catch {

        }
    }
    // MARK:- Action
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
//MARK:- UITableViewDataSource
extension DetailFavoriteViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberListFavorite = listVideo?.count {
            return numberListFavorite
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(VideoFavoriteCell.self)
        let video = listVideo![indexPath.row]
        cell.configureCell(video)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        let item = listVideo![indexPath.row]
        let video = Video()
        video.channelTitle = item.channelTitle
        video.idVideo = item.idVideo
        video.descript = item.descript
        video.duration = item.duration
        video.isFavorite = item.isFavorite
        video.viewCount = item.viewCount
        detailVideoVC.video = video
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}
//MARK:- UITableViewDelegate
extension DetailFavoriteViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

