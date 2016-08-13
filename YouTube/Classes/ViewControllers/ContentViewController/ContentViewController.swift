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
    private var dataOfVideo: Results<Video>?
    @IBOutlet weak private var indicatorView: UIActivityIndicatorView!
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
        if let videos = Video.getVideos(pageId) where videos.count > 0 {
            self.indicatorView.hidden = true
            dataOfVideo = videos
            loadData()
        } else {
            self.indicatorView.startAnimating()
            loadVideos(pageId, pageToken: nil)
        }
    }
    // MARK:- Register Cell
    private func configureContentViewCOntroller() {
        self.contentTableView.registerNib(HomeCell)
    }
    // MARK:- Load Data
    func loadData() {
        do {
            let realm = try Realm()
            dataOfVideo = realm.objects(Video).filter("idCategory = '\(pageId)'")
            self.contentTableView.reloadData()
        } catch {

        }
    }

    private func loadVideos(id: String, pageToken: String?) {
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet,contentDetails,statistics"
        parameters["maxResults"] = "10"
        parameters["chart"] = "mostPopular"
        parameters["videoCategoryId"] = id
        parameters["regionCode"] = "VN"
        parameters["pageToken"] = pageToken
        MyVideo.loadDataFromAPI(pageId, pageToken: pageToken, parameters: parameters) { (success, nextPageToken, error) in
            if success {
                self.indicatorView.stopAnimating()
                self.indicatorView.hidden = true
                self.loadData()
                self.pageToken = nextPageToken
            } else {
            }
        }
    }
}
//MARK:- UITableViewDataSource
extension ContentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = dataOfVideo {
            return videos.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.contentTableView.dequeue(HomeCell)
        let video = self.dataOfVideo![indexPath.row]
        cell.configureCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = dataOfVideo![indexPath.row]
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == contentTableView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                if pageToken != nil {
                    loadVideos(pageId, pageToken: pageToken!)
                    contentTableView.reloadData()
                }
            }
        }
    }
}
//MARK:- UITableViewDelegate
extension ContentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

