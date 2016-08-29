//
//  DetailFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

class DetailFavoriteViewController: BaseViewController {

    @IBOutlet weak private var nameListFavoriteLabel: UILabel!
    @IBOutlet weak private var listVideoFavoriteTableView: UITableView!
    var favorite = Favorite()
    private struct Options {
        static let HeightOfRow: CGFloat = 205
        static var cellSnapshot: UIView? = nil
        static var cellIsAnimating: Bool = false
        static var cellNeedToShow: Bool = false
        static var initialIndexPath: NSIndexPath? = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func configureDetailFavoriteViewController() {
        listVideoFavoriteTableView.registerNib(HomeCell)
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        configureDetailFavoriteViewController()
        nameListFavoriteLabel.text = favorite.name
        listVideoFavoriteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        listVideoFavoriteTableView.addGestureRecognizer(longpress)

        notification()
    }

    // MARK:- Set Up Data
    override func setUpData() {

    }

    // MARK:- Notification
    func notification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addNewVideo), name: NotificationDefine.AddVideoFavorite, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deleteVideo), name: NotificationDefine.DeleteVideo, object: nil)
    }

    // MARK:- Add new video to list
    func addNewVideo(notification: NSNotification) {
        let userInfo = notification.userInfo
        let id = userInfo!["idFavorite"] as? Int ?? 0
        if id == favorite.id {
            listVideoFavoriteTableView.beginUpdates()
            var indexPaths = [NSIndexPath]()
            indexPaths.append(NSIndexPath(forRow: favorite.listVideo.count - 1, inSection: 0))
            listVideoFavoriteTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
            listVideoFavoriteTableView.endUpdates()
        }
    }

    // MARK:- Delete video from list
    func deleteVideo(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let indexPath = userInfo!["indexPath"] as? NSIndexPath {
            listVideoFavoriteTableView.beginUpdates()
            var indexPaths = [NSIndexPath]()
            indexPaths.append(indexPath)
            listVideoFavoriteTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
            listVideoFavoriteTableView.endUpdates()
        }
    }

    // MARK:- Action
    @IBAction func clickBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK:- Sort Video in FavoriteLisst
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(listVideoFavoriteTableView)
        let indexPath = listVideoFavoriteTableView.indexPathForRowAtPoint(locationInView)
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Options.initialIndexPath = indexPath
                let cell = listVideoFavoriteTableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                Options.cellSnapshot = snapshotOfCell(cell)

                var center = cell.center
                Options.cellSnapshot!.center = center
                Options.cellSnapshot!.alpha = 0.0
                listVideoFavoriteTableView.addSubview(Options.cellSnapshot!)

                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    Options.cellIsAnimating = true
                    Options.cellSnapshot!.center = center
                    Options.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    Options.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                    if finished {
                        Options.cellIsAnimating = false
                        if Options.cellNeedToShow {
                            Options.cellNeedToShow = false
                            UIView.animateWithDuration(0.25, animations: { () -> Void in
                                cell.alpha = 1
                            })
                        } else {
                            cell.hidden = true
                        }
                    }
                })
            }

        case UIGestureRecognizerState.Changed:
            if Options.cellSnapshot != nil {
                var center = Options.cellSnapshot!.center
                center.y = locationInView.y
                Options.cellSnapshot!.center = center
                if indexPath != nil && indexPath != Options.initialIndexPath {
                    if let fromIndex = indexPath?.row, toIndex = Options.initialIndexPath?.row {
                        do {
                            let realm = try Realm()
                            try realm.write({
                                favorite.listVideo.swap(toIndex, fromIndex)
                            })
                        } catch {

                        }
                    }
                    listVideoFavoriteTableView.moveRowAtIndexPath(Options.initialIndexPath!, toIndexPath: indexPath!)
                    Options.initialIndexPath = indexPath
                }
            }
        default:
            if Options.initialIndexPath != nil {
                let cell = listVideoFavoriteTableView.cellForRowAtIndexPath(Options.initialIndexPath!) as UITableViewCell!
                if Options.cellIsAnimating {
                    Options.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    Options.cellSnapshot!.center = cell.center
                    Options.cellSnapshot!.transform = CGAffineTransformIdentity
                    Options.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0

                    }, completion: { (finished) -> Void in
                    if finished {
                        Options.initialIndexPath = nil
                        Options.cellSnapshot!.removeFromSuperview()
                        Options.cellSnapshot = nil
                    }
                })
            }
        }
    }

    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()

        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

}
// MARK:- UITableViewDataSource
extension DetailFavoriteViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.listVideo.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeCell.self)
        let video = Video(favorite.listVideo[indexPath.row])
        cell.configureCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        listVideoFavoriteTableView.deselectRowAtIndexPath(indexPath, animated: false)
        let video = Video(favorite.listVideo[indexPath.row])
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = video
        detailVideoVC.delegate = self
        History.addVideoToHistory(video)
        navigationController?.pushViewController(detailVideoVC, animated: true)
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Default, title: Message.Delete) { action, index in
            let video = self.favorite.listVideo[indexPath.row]
            do {
                let realm = try Realm()
                try realm.write({
                    realm.delete(video)
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationDefine.DeleteVideo, object: nil, userInfo: ["indexPath": indexPath])
                })
            } catch {

            }
        }
        return [delete]
    }
}
// MARK:- UITableViewDelegate
extension DetailFavoriteViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}

extension DetailFavoriteViewController: DetailVideoDelegete {
    func deleteFromListFavorite(isDeleted: Bool) {
        if isDeleted == false {
            listVideoFavoriteTableView.reloadData()
        }
    }
}

