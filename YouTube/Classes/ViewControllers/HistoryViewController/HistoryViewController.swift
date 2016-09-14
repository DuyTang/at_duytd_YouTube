//
//  HistoryViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import ReachabilitySwift

private struct Options {
    static let HeightOfRow: CGFloat = 90
}

class HistoryViewController: BaseViewController {

    @IBOutlet weak private var historyTableView: UITableView!
    private var videos: Results<History>!
    private var date: [String] = []
    private var dragVideo: DraggalbeVideo!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Life Cycle
    override func viewWillAppear(animated: Bool) {
        date.removeAll()
        loadData()
    }

    override func setUpUI() {
        navigationController?.navigationBarHidden = true
        historyTableView.registerNib(HistoryCell)
        dragVideo.draggbleProgress()
        dragVideo.addActionToView()
    }

    override func setUpData() {
        dragVideo = DraggalbeVideo(rootViewController: tabBarController!)
    }

    private func loadData() {
        videos = RealmManager.getAllHistory()
        loadDate()
    }

    // MARK:- Private Function
    private func loadDate() {
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

    private func getListVideo(date: String) -> [History] {
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

    private func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            return (networkStatus != 0)
        }
        catch {
            return false
        }
    }

    // MARK:- Action
    @IBAction private func deleteAllHistory(sender: UIButton) {
        let alert = UIAlertController(title: Message.Title, message: Message.DeleteMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Message.OkButton, style: .Default, handler: { action in
            History.cleanData()
            self.date.removeAll()
            self.historyTableView.reloadData()
            }))
        alert.addAction(UIAlertAction(title: Message.CancelButton, style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
//MARK:- Extension
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

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Color.TitleColor
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
        if hasConnectivity() {
            let video = Video(history: getListVideo(date[indexPath.section])[indexPath.row])
            dragVideo.prensetDetailVideoController(video, isFavorite: false)
        } else {
            showAlert(Message.Title, message: "No Connect", cancelButton: Message.OkButton)
        }
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}

