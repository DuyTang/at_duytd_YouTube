//
//  HistoryViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

    @IBOutlet weak private var historyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Configure HistoryViewController
    private func configureHistoryController() {
        self.historyTableView.registerNib(HomeCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.navigationController?.navigationBarHidden = true
        self.configureHistoryController()
    }
    // MARK:- Set Up Data
    override func setUpData() {

    }
}
//MARK:- UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeue(HomeCell)
        cell.configureCell()
        return cell
    }
}
//MARK:- UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

