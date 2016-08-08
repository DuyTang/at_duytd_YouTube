//
//  ContentViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class ContentViewController: BaseViewController {

    @IBOutlet weak private var contentTableView: UITableView!
    var pageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Register Cell
    private func configureContentViewCOntroller() {
        self.contentTableView.registerNib(HomeCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.configureContentViewCOntroller()
    }
}
//MARK:- UITableViewDataSource
extension ContentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.contentTableView.dequeue(HomeCell)
        cell.configureCell()
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.idVideo = "Y7nkqZvQcBQ"
        detailVideoVC.isFavorite = false
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}
//MARK:- UITableViewDelegate
extension ContentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

