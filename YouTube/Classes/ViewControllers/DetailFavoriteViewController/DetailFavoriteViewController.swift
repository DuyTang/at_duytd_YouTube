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

private struct Options {
    static let HeightOfRow: CGFloat = 205
}

class DetailFavoriteViewController: BaseViewController {

    @IBOutlet weak private var nameListFavoriteLabel: UILabel!
    @IBOutlet weak private var listVideoFavoriteTableView: UITableView!
    var favorite = Favorite()
    private var cellSnapshot: UIView?
    private var cellIsAnimating = false
    private var cellNeedToShow = false
    private var initialIndexPath: NSIndexPath?
    private var dragVideo: DraggalbeVideo!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Life Cycle
    override func setUpUI() {
        listVideoFavoriteTableView.registerNib(HomeCell)
        nameListFavoriteLabel.text = favorite.name
        listVideoFavoriteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        listVideoFavoriteTableView.addGestureRecognizer(longpress)
        notification()
        dragVideo.draggbleProgress()
        dragVideo.addActionToView()
    }

    override func setUpData() {
        dragVideo = DraggalbeVideo(rootViewController: tabBarController!)
    }

    // MARK:- Private Function
    private func notification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addNewVideo), name: NotificationDefine.AddVideoFavorite, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deleteVideo), name: NotificationDefine.DeleteVideo, object: nil)
    }

    @objc private func addNewVideo(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let id = userInfo!["idFavorite"] as? Int where id == favorite.id {

            listVideoFavoriteTableView.beginUpdates()
            var indexPaths = [NSIndexPath]()
            indexPaths.append(NSIndexPath(forRow: favorite.listVideo.count - 1, inSection: 0))
            listVideoFavoriteTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
            listVideoFavoriteTableView.endUpdates()

        }
    }

    @objc private func deleteVideo(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let indexPath = userInfo!["indexPath"] as? NSIndexPath {
            listVideoFavoriteTableView.beginUpdates()
            var indexPaths = [NSIndexPath]()
            indexPaths.append(indexPath)
            listVideoFavoriteTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Left)
            listVideoFavoriteTableView.endUpdates()
        }
    }

    @objc private func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let locationInView = longPress.locationInView(listVideoFavoriteTableView)
        let indexPath = listVideoFavoriteTableView.indexPathForRowAtPoint(locationInView)
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                initialIndexPath = indexPath
                let cell = listVideoFavoriteTableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                cellSnapshot = snapshotOfCell(cell)

                var center = cell.center
                cellSnapshot!.center = center
                cellSnapshot!.alpha = 0.0
                listVideoFavoriteTableView.addSubview(cellSnapshot!)

                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    self.cellIsAnimating = true
                    self.cellSnapshot!.center = center
                    self.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    self.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                    if finished {
                        self.cellIsAnimating = false
                        if self.cellNeedToShow {
                            self.cellNeedToShow = false
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
            if let cellSnapshot = cellSnapshot {
                var center = cellSnapshot.center
                center.y = locationInView.y
                cellSnapshot.center = center
                if indexPath != nil && indexPath != initialIndexPath {
                    if let fromIndex = indexPath?.row, toIndex = initialIndexPath?.row {
                        do {
                            let realm = try Realm()
                            try realm.write({
                                favorite.listVideo.swap(toIndex, fromIndex)
                            })
                        } catch {

                        }
                    }
                    listVideoFavoriteTableView.moveRowAtIndexPath(initialIndexPath!, toIndexPath: indexPath!)
                    initialIndexPath = indexPath
                }
                let contentY = listVideoFavoriteTableView.contentOffset.y + listVideoFavoriteTableView.frame.height
                if cellSnapshot.frame.y < listVideoFavoriteTableView.contentOffset.y {
                    scrollToUp()
                } else if cellSnapshot.frame.y + cellSnapshot.frame.height > contentY && listVideoFavoriteTableView.contentOffset.y + listVideoFavoriteTableView.frame.height < listVideoFavoriteTableView.contentSize.height {
                    scrollToDown()
                }
            }
        default:
            if let initialIndexPath = initialIndexPath {
                let cell = listVideoFavoriteTableView.cellForRowAtIndexPath(initialIndexPath) as UITableViewCell!
                if cellIsAnimating {
                    cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.cellSnapshot!.center = cell.center
                    self.cellSnapshot!.transform = CGAffineTransformIdentity
                    self.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0

                    }, completion: { (finished) -> Void in
                    if finished {
                        self.initialIndexPath = nil
                        self.cellSnapshot!.removeFromSuperview()
                        self.cellSnapshot = nil
                    }
                })
            }
        }
    }

    private func snapshotOfCell(inputView: UIView) -> UIView {
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

    private func scrollToUp() {
        if listVideoFavoriteTableView.contentOffset.y != 0 {
            let y = listVideoFavoriteTableView.contentOffset.y - 5
            listVideoFavoriteTableView.contentOffset.y = y > 0 ? y : 0
            if let cellSnapshot = cellSnapshot {
                if cellSnapshot.frame.y < listVideoFavoriteTableView.contentOffset.y {
                    scrollToUp()
                }
            }
        }
    }

    private func scrollToDown() {
        let y = listVideoFavoriteTableView.contentOffset.y + 5
        if y + listVideoFavoriteTableView.frame.height < listVideoFavoriteTableView.contentSize.height {
            listVideoFavoriteTableView.contentOffset.y = y
            if let cellSnapshot = cellSnapshot {
                let contentY = listVideoFavoriteTableView.contentOffset.y + listVideoFavoriteTableView.frame.height
                if cellSnapshot.frame.y < listVideoFavoriteTableView.contentOffset.y {
                    scrollToUp()
                } else if cellSnapshot.frame.y + cellSnapshot.frame.height > contentY && listVideoFavoriteTableView.contentOffset.y + listVideoFavoriteTableView.frame.height < listVideoFavoriteTableView.contentSize.height {
                    scrollToDown()
                }
            }
        }
    }

    // MARK:- Action
    @IBAction private func clickBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

}

// MARK:- Extension
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
        dragVideo.videoPlayerViewController.delegate = self
        dragVideo.prensetDetailVideoController(video)
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Default, title: Message.Delete) { action, index in
            let video = self.favorite.listVideo[indexPath.row]
            RealmManager.deleteRealm(video)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationDefine.DeleteVideo, object: nil, userInfo: ["indexPath": indexPath])
        }
        return [delete]
    }
}

extension DetailFavoriteViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Options.HeightOfRow
    }
}

extension DetailFavoriteViewController: DetailVideoDelegate {
    func deleteFromListFavorite(isDeleted: Bool) {
        if isDeleted == false {
            listVideoFavoriteTableView.reloadData()
        }
    }
}

