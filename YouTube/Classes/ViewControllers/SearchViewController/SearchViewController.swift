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

    private struct Options {
        static let HeightOfRow: CGFloat = 40
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
        searchResultTableView.registerNib(DecriptVideoCell)
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

    }

    private func loadListName(key: String) {

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
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeue(DecriptVideoCell.self)
        return cell
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
        isSearching = true
        searchResultTableView.hidden = false
    }
}