//
//  History.swift
//  YouTube
//
//  Created by Duy Tang on 8/17/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftUtils

class History: Object {
    dynamic var idVideo = ""
    dynamic var idCategory = ""
    dynamic var title = ""
    dynamic var viewCount = ""
    dynamic var duration = ""
    dynamic var channelTitle = ""
    dynamic var descript = ""
    dynamic var thumbnail = ""
    dynamic var date = ""
    dynamic var time = ""

    func initFromVideo(video: Video, datetime: NSDate) {
        self.idVideo = video.idVideo ?? ""
        self.idCategory = video.idCategory ?? ""
        self.title = video.title ?? ""
        self.viewCount = video.viewCount ?? ""
        self.duration = video.duration ?? ""
        self.channelTitle = video.channelTitle ?? ""
        self.descript = video.descript ?? ""
        self.thumbnail = video.thumbnail ?? ""
        self.date = datetime.toString(DateFormat.Date, localized: true)
        self.time = datetime.toString(DateFormat.Time24NoSec, localized: true)
    }

    class func cleanData() {
        do {
            let realm = try Realm()
            let videos = realm.objects(self)
            try realm.write({
                realm.delete(videos)
            })
        } catch {

        }
    }

    class func addVideoToHistory(video: Video) {
        do {
            let realm = try Realm()
            let historyVideo = History()
            historyVideo.initFromVideo(video, datetime: NSDate())
            try realm.write({
                realm.add(historyVideo)
            })
            NSNotificationCenter.defaultCenter().postNotificationName(AppDefine.AddVideoToHistory, object: nil)
        } catch {

        }
    }
}
