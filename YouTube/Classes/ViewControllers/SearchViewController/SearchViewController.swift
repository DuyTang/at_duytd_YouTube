//
//  SearchViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/23/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import ObjectMapper

private struct Options {
    static let HeightOfRow: CGFloat = 30
    static let HeightOfVideoRow: CGFloat = 83
    static let MaxResult = 10
}

class SearchViewController: BaseViewController {

    @IBOutlet weak private var searchResultTableView: UITableView!
    @IBOutlet weak private var videoSearchTableView: UITableView!
    @IBOutlet weak private var keySearchBar: UISearchBar!
    private var isSearching = false
    private var listKey = [String]()
    private var listVideo = [Video]()
    private var key: String = ""
    private var nextPage: String?
    private var isLoading = false
    private var loadmoreActive = true
    @IBOutlet weak private var deleteKeyButton: UIButton!
    private var dragVideo: DraggalbeVideo!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Lefe Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchResultTableView.hidden = true
    }

    override func setUp() {
        modalPresentationStyle = .OverCurrentContext
    }

    override func setUpUI() {
        searchResultTableView.registerNib(ResultSearchCell)
        videoSearchTableView.registerNib(VideoFavoriteCell)
        keySearchBar.backgroundImage = UIImage()
        keySearchBar.becomeFirstResponder()
        if let textField = keySearchBar.valueForKey("_searchField") as? UITextField {
            textField.clearButtonMode = .Never
        }
        dragVideo.draggbleProgress()
        dragVideo.addActionToView()
    }

    override func setUpData() {
        dragVideo = DraggalbeVideo(rootViewController: tabBarController!)
        loadData()
    }

    private func loadData() {
        loadListName(key)
    }

    // MARK:- Private Function
    private func convertStringToArray(string: String) -> [String] {
        var listElement = string.stringByReplacingOccurrencesOfString("[", withString: "").stringByReplacingOccurrencesOfString("]", withString: "").componentsSeparatedByString(",")
        listElement.removeAtIndex(0)
        let listName = listElement.map { (text) -> String in
            let temp = text.stringByReplacingOccurrencesOfString("\"", withString: "")
            let transform = "Any-Hex/Java"
            let convertedString = temp.mutableCopy() as? NSMutableString
            CFStringTransform(convertedString, nil, transform as NSString, true)
            return String(convertedString!)
        }
        return listName
    }

    // MARK:- Action
    @IBAction private func backToHomeViewController(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction private func deleteKey(sender: AnyObject) {
        key = ""
        keySearchBar.text = ""
        deleteKeyButton.hidden = true
        listKey.removeAll()
        searchResultTableView.reloadData()
        listVideo.removeAll()
        videoSearchTableView.reloadData()
        searchResultTableView.hidden = true
        view.endEditing(true)
    }

    // MARK:- Webservice
    private func loadListName(key: String) {
        self.listKey.removeAll()
        var parameters = [String: AnyObject]()
        parameters["q"] = key
        VideoService.searchKey(parameters) { (response) in
            if let data = response as? String {
                self.listKey = self.convertStringToArray(data)
                if self.listKey == [""] {
                    self.searchResultTableView.hidden = true
                } else {
                    self.searchResultTableView.reloadData()
                }
            }
        }
    }

    private func loadVideoFromKey(key: String, nextPage: String?) {
        if isLoading || key.isEmpty {
            return
        }
        isLoading = true
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["maxResults"] = Options.MaxResult
        parameters["pageToken"] = nextPage
        parameters["q"] = key
        VideoService.searchVideoForKey(parameters) { (success, response, nextPageToken, error) in
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
                        VideoService.loadDetailVideoFromIdVideo(parameter, completion: { (response) in
                            if let detailVideo = response as? NSArray {
                                for item in detailVideo {
                                    if let detailVideo = item.objectForKey("contentDetails") as? NSDictionary {
                                        video?.duration = detailVideo["duration"] as? String ?? ""
                                    }
                                    if let statistics = item.objectForKey("statistics") as? NSDictionary {
                                        video?.viewCount = statistics["viewCount"] as? String ?? ""
                                    }
                                    if !(video?.channelId.isEmpty)! {
                                        var parametersThumbnail = [String: AnyObject]()
                                        parametersThumbnail["part"] = "snippet"
                                        parametersThumbnail["id"] = video?.channelId
                                        VideoService.getChannelThumbnail(parametersThumbnail, completion: { (response) in
                                            video?.channelThumnail = response as? String ?? ""
                                            self.listVideo.append(video!)
                                            self.videoSearchTableView.reloadData()
                                        })
                                    } else {
                                        continue
                                    }
                                }
                            }
                            self.isLoading = false
                        })
                    }
                    self.hideLoading()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            } else {
                self.showAlert(Message.LoadVideoFail, message: Message.NoData, cancelButton: Message.CancelButton)
            }
        }
    }

}

// MARK:- Extension
extension SearchViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return listKey.count ?? 0
        } else {
            return listVideo.count ?? 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = searchResultTableView.dequeue(ResultSearchCell.self)
            let nameVideo = listKey[indexPath.row]
            cell.configResultSearchCell(nameVideo)
            return cell
        } else {
            let cell = videoSearchTableView.dequeue(VideoFavoriteCell)
            cell.configureCell(listVideo[indexPath.row])
            return cell
        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 0 {
            if listKey.count > 0 {
                showLoading()
                loadVideoFromKey(listKey[indexPath.row], nextPage: nextPage)
                searchResultTableView.hidden = true
                view.endEditing(true)
            }
        } else {
            dragVideo.prensetDetailVideoController(listVideo[indexPath.row], isFavorite: false)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && loadmoreActive {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            loadVideoFromKey(key, nextPage: nextPage)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return Options.HeightOfRow
        } else {
            return Options.HeightOfVideoRow
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        key = searchBar.text!
        deleteKeyButton.hidden = false
        isSearching = true
        loadListName(key)
        searchResultTableView.hidden = false
        if key.isEmpty && listKey.isEmpty {
            searchResultTableView.hidden = true
            listVideo.removeAll()
            videoSearchTableView.reloadData()
        }

    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        listVideo.removeAll()
        loadVideoFromKey(searchBar.text!, nextPage: nextPage)
        searchResultTableView.hidden = true
        videoSearchTableView.reloadData()
        view.endEditing(true)
    }

}
