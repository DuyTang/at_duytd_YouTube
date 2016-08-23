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
    var videoFavorites: Results<VideoFavorite>?
    private struct Options {
        static let HeightOfRow: CGFloat = 230
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func configureDetailFavoriteViewController() {
        listVideoFavoriteTableView.registerNib(HomeCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        configureDetailFavoriteViewController()
        nameListFavoriteLabel.text = favorite.name
    }
    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }
    private func loadData() {
        do {
            let realm = try Realm()
            videoFavorites = realm.objects(VideoFavorite).filter("idListFavorite = %@", favorite.id)
        } catch {

        }
    }
    // MARK:- Action
    @IBAction func clickBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
//MARK:- UITableViewDataSource
extension DetailFavoriteViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberListFavorite = videoFavorites?.count {
            return numberListFavorite
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeCell.self)
        let video = Video(videoFavorites![indexPath.row])
        cell.configureCell(video)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let video = Video(videoFavorites![indexPath.row])
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = video
        detailVideoVC.delegate = self
        History.addVideoToHistory(video)
        navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}
//MARK:- UITableViewDelegate
extension DetailFavoriteViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}

extension DetailFavoriteViewController: DetailVideoDelegete {
    func deleteFromListFavorite(isDeleted: Bool) {
        if isDeleted == false {
            listVideoFavoriteTableView.reloadData()
        }
    }
}

