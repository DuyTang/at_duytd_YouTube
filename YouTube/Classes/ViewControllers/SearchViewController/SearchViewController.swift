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
    // MARK:- Set Up
    override func setUp() {
        setAttributeViewController()
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        config()
        showResultTableView()
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

    private func setAttributeViewController() {
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .OverCurrentContext
        modalTransitionStyle = .CrossDissolve
    }

    private func showResultTableView() {
        searchResultTableView.hidden = !isSearching
    }

    private func loadData() {
        loadListName(key)
    }

    private func loadListName(key: String) {
        var parameters = [String: AnyObject]()
        parameters["q"] = key
        MyVideo.searchKey(parameters) { (response) in
            if let data = response as? String {
                self.listKey = self.convertStringToArray(data)
                self.searchResultTableView.reloadData()
            }
        }
    }

    private func convertStringToArray(string: String) -> [String] {
        var listElement = string.stringByReplacingOccurrencesOfString("[", withString: "").stringByReplacingOccurrencesOfString("]", withString: "").componentsSeparatedByString(",")
        listElement.removeAtIndex(0)
        return listElement
    }

    @IBAction func backToHomeViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

//MARK:- Extension UITableView
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
        let nameVideo = listKey[indexPath.row].stringByRemovingPercentEncoding!
        cell.configResultSearchCell(nameVideo)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}

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
        searchResultTableView.hidden = false
        loadListName(key)
        if key.isEmpty {
            searchResultTableView.hidden = true
        }
    }
}