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
    struct Options {
        static let HeightOfRow: CGFloat = 90
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        date.removeAll()
        loadData()
    }

    // MARK:- Configure HistoryViewController
    private func configureHistoryController() {
        historyTableView.registerNib(HistoryCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        navigationController?.navigationBarHidden = true
        configureHistoryController()
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
    // MARK:- Load Date Watched
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
        historyTableView.reloadData()
    }
    // MARK: - Load List Video By Date
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
    // MARK:- Clear History
    @IBAction func deleteAllHistory(sender: UIButton) {
        History.cleanData()
        date.removeAll()
        historyTableView.reloadData()
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
            return Message.NoData
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
        let cell = historyTableView.dequeue(HistoryCell.self)
        let video = getListVideo(date[indexPath.section])[indexPath.row]
        cell.configureHistoryCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        let video = getListVideo(date[indexPath.section])[indexPath.row]
        detailVideoVC.video = Video(history: video)
        navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}
//MARK:- UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}

