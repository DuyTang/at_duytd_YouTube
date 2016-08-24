//
//  SearchViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/23/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak private var searchResultTableView: UITableView!
    @IBOutlet weak private var keySearchBar: UISearchBar!
    private var isSearching = false
    private var listKey = [String]()
    private var key: String = ""

    private struct Options {
        static let HeightOfRow: CGFloat = 30
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        keySearchBar.text = ""
        searchResultTableView.hidden = true
    }
    // MARK:- Set Up
    override func setUp() {
        modalPresentationStyle = .OverCurrentContext
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        keySearchBar.backgroundImage = UIImage()
        config()
        keySearchBar.becomeFirstResponder()
    }
    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }
    // MARK:- Configuer SearchViewController
    private func config() {
        searchResultTableView.registerNib(ResultSearchCell)
    }

    // MARK:- loadData
    private func loadData() {
        loadListName(key)
    }
    // MARK:- Load List Key Search
    private func loadListName(key: String) {
        self.listKey.removeAll()
        var parameters = [String: AnyObject]()
        parameters["q"] = key
        MyVideo.searchKey(parameters) { (response) in
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
    // MARK:- Convert Response to String Array
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
    // MARK: - Action
    @IBAction func backToHomeViewController(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}

//MARK:- Extension UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listKey.isEmpty {
            return 0
        } else {
            return listKey.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeue(ResultSearchCell.self)
        let nameVideo = listKey[indexPath.row]
        cell.configResultSearchCell(nameVideo)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let videoSearchVC = VideoSearchViewController()
        videoSearchVC.key = listKey[indexPath.row]
        navigationController?.pushViewController(videoSearchVC, animated: true)
    }
}
//MARK:- Extension UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}

//MARK:- Extension UISearchBar

extension SearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        key = searchBar.text!
        isSearching = true
        loadListName(key)
        searchResultTableView.hidden = false

        if key.isEmpty && listKey.isEmpty {
            searchResultTableView.hidden = true
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let videoSearchVC = VideoSearchViewController()
        videoSearchVC.key = searchBar.text!
        navigationController?.pushViewController(videoSearchVC, animated: true)
    }
}