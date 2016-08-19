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
    private var date: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addNewVideo), name: "addVideoToHistory", object: nil)
    }
    func addNewVideo() {
        self.historyTableView.beginUpdates()
        var indexPaths = [NSIndexPath]()
        indexPaths.append(NSIndexPath(forRow: self.videos.count - 1, inSection: 0))
        self.historyTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
        self.historyTableView.endUpdates()
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
        var currentDate = videos[0].date
        date.append(currentDate)
        for i in 1...videos.count - 1 {
            if videos[i].date != currentDate {
                currentDate = videos[i].date
                date.append(currentDate)
            }

        }
    }
    func getListVideoFromDate(date: String) -> [History] {
        var listVideo = [History]()
        for i in 0...videos.count - 1 {
            if videos[i].date == date {
                listVideo.append(videos[i])
            }
        }
        return listVideo
    }

    @IBAction func deleteAllHistory(sender: UIButton) {
        History.cleanData()
        self.historyTableView.reloadData()
    }
}
//MARK:- UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if date.count == 0 {
            return 1
        } else {
            return date.count
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return date[section]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videos != nil {
            return getListVideoFromDate(date[section]).count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeue(HistoryCell.self)
        let video = getListVideoFromDate(date[indexPath.section])[indexPath.row]
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

