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
    private var listVideo: [[History]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addNewVideo), name: AppDefine.AddVideoToHistory, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        date = []
        loadData()
    }
    func addNewVideo() {
        self.historyTableView.beginUpdates()
        var indexPaths = [NSIndexPath]()
        indexPaths.append(NSIndexPath(forRow: getListVideo(date[date.count - 1]).count - 1, inSection: date.count - 1))
        self.historyTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
        self.historyTableView.endUpdates()
        // self.historyTableView.reloadData()

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
        loadDate()
    }

    func loadDate() {
        if videos.count > 0 {
            var currentDate = videos[0].date
            date.append(currentDate)
            for i in 0...videos.count - 1 {
                if videos[i].date != currentDate {
                    currentDate = videos[i].date
                    date.append(currentDate)
                }
            }
        }
        self.historyTableView.reloadData()
    }
    func getListVideo(date: String) -> [History] {
        var list = [History]()
        if videos.count > 0 {
            for video in videos {
                if video.date == date {
                    list.append(video)
                }
            }
        }
        return list
    }

    @IBAction func deleteAllHistory(sender: UIButton) {
        History.cleanData()
        date = []
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
        if date.count > 0 {
            return date[section]
        } else {
            return "No data"
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if date.count > 0 {
            return getListVideo(date[section]).count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeue(HistoryCell.self)
        let video = getListVideo(date[indexPath.section])[indexPath.row]
        cell.configureHistoryCell(video)
        return cell
    }
}
//MARK:- UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CellDefine.HeightOfNomarlCell
    }
}

