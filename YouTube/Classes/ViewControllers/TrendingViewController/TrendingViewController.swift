//
//  TrendingViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/16/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class TrendingViewController: BaseViewController {
    @IBOutlet weak var trendingTableView: UITableView!
    private var trendingVideos: Results<Video>!
    private var idCategory = "0"
    private var nextPage: String?
    private var isLoading = false
    private var loadmoreActive = true
    private struct Options {
        static let HeightOfRow: CGFloat = 205
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Configure TrendingViewControllers
    func configureTrendingViewController() {
        trendingTableView.registerNib(HomeCell)
    }

    // MARk:- Set up UI
    override func setUpUI() {
        configureTrendingViewController()
    }

    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
        if let videos = Video.getVideos(idCategory) where videos.count > 0 {
            trendingVideos = videos
        } else {
            loadTrendingVideo(idCategory, pageToken: nil)
        }
    }

    // MARK:- Load Data

    func loadData() {
        do {
            let realm = try Realm()
            trendingVideos = realm.objects(Video).filter("idCategory = %@", idCategory)
            trendingTableView.reloadData()
        } catch {

        }
    }

    func loadTrendingVideo(id: String, pageToken: String?) {

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
            }
            self.isLoading = false
        }
    }
}

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
        let video = trendingVideos![indexPath.row]
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = video
        History.addVideoToHistory(video)
        navigationController?.pushViewController(detailVideoVC, animated: true)
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
