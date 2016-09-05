//
//  TrendingViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/16/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class TrendingViewController: BaseViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var trendingTableView: UITableView!
    private var trendingVideos: Results<Video>!
    private var idCategory = "0"
    private var nextPage: String?
    private var isLoading = false
    private var loadmoreActive = true
    private var isPlaying = false
    private struct Options {
        static let HeightOfRow: CGFloat = 205
    }
    private var dragVideo: DraggalbeVideo!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func setUp() {
        modalPresentationStyle = .OverCurrentContext
    }
    // MARk:- Set up UI
    override func setUpUI() {
        trendingTableView.registerNib(HomeCell)
        dragVideo.draggbleProgress()
        dragVideo.addActionToView()
    }

    // MARK:- Set Up Data
    override func setUpData() {
        dragVideo = DraggalbeVideo(rootViewController: self.tabBarController!)
        loadData()
        if let videos = Video.getVideos(idCategory) where videos.count > 0 {
            trendingVideos = videos
        } else {
            loadTrendingVideo(idCategory, pageToken: nil)
        }
    }

    // MARK:- Load Data
    private func loadData() {
        trendingVideos = RealmManager.getListVideo(idCategory)
        trendingTableView.reloadData()
    }

    private func loadTrendingVideo(id: String, pageToken: String?) {
        if isLoading {
            return
        }
        isLoading = true
        showLoading()
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet,contentDetails,statistics"
        parameters["chart"] = "mostPopular"
        parameters["regionCode"] = "VN"
        parameters["maxResults"] = "10"
        parameters["pageToken"] = nextPage
        VideoService.loadDataFromAPI(idCategory, parameters: parameters) { (success, nextPageToken, error) in
            if success {
                self.hideLoading()
                self.trendingTableView.reloadData()
                self.nextPage = nextPageToken
                if nextPageToken == nil {
                    self.loadmoreActive = false
                }
            } else {
                self.showAlert(Message.Title, message: Message.LoadDataFail, cancelButton: Message.OkButton)
            }
            self.isLoading = false
        }
    }
}
//MARK:- Extension UITableView
extension TrendingViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = trendingVideos {
            return videos.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = trendingTableView.dequeue(HomeCell.self)
        let video = trendingVideos[indexPath.row]
        cell.configureCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dragVideo.prensetDetailVideoController(trendingVideos[indexPath.row])
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && loadmoreActive {
            loadTrendingVideo(idCategory, pageToken: nextPage)
        }
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}
