//
//  HistoryViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: BaseViewController {

    @IBOutlet weak private var historyTableView: UITableView!
    private var videos: Results<History>!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Configure HistoryViewController
    private func configureHistoryController() {
        self.historyTableView.registerNib(HistoryCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.navigationController?.navigationBarHidden = true
        self.configureHistoryController()
    }
    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }
    // MARK:- Load Data
    func loadData() {
        do {
            let realm = try Realm()
            videos = realm.objects(History)
        } catch {

        }
    }
}
//MARK:- UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = videos {
            return videos.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeue(HistoryCell.self)
        let video = videos[indexPath.row]
        cell.configureHistoryCell(video)
        return cell
    }
}
//MARK:- UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppDefine.heightOfNomarlCell
    }
}

