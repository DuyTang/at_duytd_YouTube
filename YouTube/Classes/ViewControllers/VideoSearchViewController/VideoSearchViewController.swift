//
//  VideoSearchViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/24/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import ObjectMapper

class VideoSearchViewController: BaseViewController {

    @IBOutlet weak var videoSearchTableView: UITableView!
    var key: String = ""
    var listVideo = [Video]()
    private var nextPage: String?
    private var isLoading = false
    private var loadmoreActive = true
    private struct Options {
        static let MaxResult = 10
        static let HeightOfRow: CGFloat = 90
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Config VideoSearchViewController
    private func configVideoSearchViewController() {
        videoSearchTableView.registerNib(VideoFavoriteCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        configVideoSearchViewController()
    }
    // MARK:- Set Up Data
    override func setUpData() {
        listVideo.removeAll()
        loadData()
    }
    // MARK:- LoadData
    private func loadData() {
        loadVideoFromKey(key, nextPage: nil)
    }
    // MARK:- Load Data From Key
    private func loadVideoFromKey(key: String, nextPage: String?) {
        if isLoading {
            return
        }
        isLoading = true
        showLoading()
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["maxResults"] = Options.MaxResult
        parameters["pageToken"] = nextPage
        parameters["q"] = key
        MyVideo.searchVideoForKey(parameters) { (success, response, nextPageToken, error) in
            if success {
                self.nextPage = nextPageToken
                if nextPageToken == nil {
                    self.loadmoreActive = false
                }
                if let videos = response as? NSArray {
                    for item in videos {
                        let video = Mapper<Video>().map(item)
                        var parameter = [String: AnyObject]()
                        parameter["part"] = "contentDetails,statistics"
                        parameter["id"] = video?.idVideo
                        MyVideo.loadDetailVideoFromIdVideo(parameter, completion: { (response) in
                            if let detailVideo = response as? NSArray {
                                for item in detailVideo {
                                    if let detailVideo = item.objectForKey("contentDetails") as? NSDictionary {
                                        video?.duration = detailVideo["duration"] as? String ?? ""
                                    }
                                    if let statistics = item.objectForKey("statistics") as? NSDictionary {
                                        video?.viewCount = statistics["viewCount"] as? String ?? ""
                                    }
                                    self.listVideo.append(video!)
                                    self.videoSearchTableView.reloadData()
                                }
                            }
                        })
                    }
                    self.hideLoading()
                }
            } else {
                self.showAlert(Message.LoadVideoFail, message: Message.NoData, cancelButton: Message.CancelButton)
            }
            self.isLoading = false
        }
    }
    // MARK:- Action
    @IBAction func backToSearchViewController(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
//MARK:- Extension UITableViewDataSource
extension VideoSearchViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listVideo.count > 0 {
            return listVideo.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = videoSearchTableView.dequeue(VideoFavoriteCell)
        cell.configureCell(listVideo[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = listVideo[indexPath.row]
        navigationController?.pushViewController(detailVideoVC, animated: true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && loadmoreActive {
            loadVideoFromKey(key, nextPage: nextPage)
        }
    }
}
//MARK:- Extension UITableViewDelegate
extension VideoSearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}
