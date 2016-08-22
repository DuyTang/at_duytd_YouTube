//
//  ContentViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class ContentViewController: BaseViewController {

    @IBOutlet weak private var contentTableView: UITableView!
    var pageIndex = 0
    var pageId = ""
    var pageToken: String?
    private var homeVideos: Results<Video>?
    private var isLoading = false
    private var loadmoreActive = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.configureContentViewCOntroller()
    }
    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
        if let videos = Video.getVideos(pageId) where videos.count > 0 {
            homeVideos = videos
        } else {
            loadVideos(pageId, pageToken: nil)
        }
    }
    // MARK:- Register Cell
    private func configureContentViewCOntroller() {
        contentTableView.registerNib(HomeCell)
    }
    // MARK:- Load Data
    func loadData() {
        do {
            let realm = try Realm()
            homeVideos = realm.objects(Video).filter("idCategory = %@", pageId)
            contentTableView.reloadData()
        } catch {

        }
    }

    private func loadVideos(id: String, pageToken: String?) {
        if isLoading {
            return
        }
        isLoading = true
        showLoading()
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet,contentDetails,statistics"
        parameters["maxResults"] = "10"
        parameters["chart"] = "mostPopular"
        parameters["videoCategoryId"] = id
        parameters["regionCode"] = "VN"
        parameters["pageToken"] = pageToken
        MyVideo.loadDataFromAPI(pageId, parameters: parameters) { (success, nextPageToken, error) in
            if success {
                self.hideLoading()
                self.contentTableView.reloadData()
                self.pageToken = nextPageToken
                if nextPageToken == nil {
                    self.loadmoreActive = false
                }
            }
            self.isLoading = false
        }
    }

}
//MARK:- UITableViewDataSource
extension ContentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = homeVideos {
            return videos.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeue(HomeCell)
        let video = homeVideos![indexPath.row]
        cell.configureCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = homeVideos![indexPath.row]
        History.addVideoToHistory(homeVideos![indexPath.row])
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && loadmoreActive {
            loadVideos(pageId, pageToken: pageToken)
        }
    }

}
//MARK:- UITableViewDelegate
extension ContentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CellDefine.HeightOfHomeCell
    }

}

