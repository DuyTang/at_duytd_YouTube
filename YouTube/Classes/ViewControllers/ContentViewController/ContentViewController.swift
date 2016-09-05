//
//  ContentViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
private struct Options {
    static let HeightOfHomeCell: CGFloat = 205
}

class ContentViewController: BaseViewController {

    @IBOutlet weak private var contentTableView: UITableView!
    var pageIndex = 0
    var pageId = ""
    var pageToken: String?
    private var homeVideos: Results<Video>?
    private var isLoading = false
    private var loadmoreActive = true
    private var dragVideo: DraggalbeVideo!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Life Cycle
    override func setUpUI() {
        contentTableView.registerNib(HomeCell)
        dragVideo.draggbleProgress()
        dragVideo.addActionToView()
    }

    override func setUpData() {
        dragVideo = DraggalbeVideo(rootViewController: self.parentViewController!)
        loadData()
        if let videos = Video.getVideos(pageId) where videos.count > 0 {
            homeVideos = videos
        } else {
            loadVideos(pageId, pageToken: nil)
        }
    }

    private func loadData() {
        homeVideos = RealmManager.getListVideo(pageId)
        contentTableView.reloadData()
    }

    // MARK:- Webservice
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
        VideoService.loadDataFromAPI(pageId, parameters: parameters) { (success, nextPageToken, error) in
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
        dragVideo.prensetDetailVideoController(homeVideos![indexPath.row])
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
        return Options.HeightOfHomeCell
    }

}

