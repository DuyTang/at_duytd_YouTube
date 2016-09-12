//
//  History.swift
//  YouTube
//
//  Created by Duy Tang on 8/17/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUtils

protocol HistoryObject {
    init?(_ video: Video)
}

class History: Object, HistoryObject {
    dynamic var idVideo = ""
    dynamic var idCategory = ""
    dynamic var title = ""
    dynamic var viewCount = ""
    dynamic var duration = ""
    dynamic var channelId = ""
    dynamic var channelTitle = ""
    dynamic var channelThumbnail = ""
    dynamic var descript = ""
    dynamic var thumbnail = ""
    dynamic var date = ""
    dynamic var time = ""

    required convenience init(_ video: Video) {
        self.init()
        let datetime = NSDate()
        idVideo = video.idVideo ?? ""
        idCategory = video.idCategory ?? ""
        title = video.title ?? ""
        viewCount = video.viewCount ?? ""
        duration = video.duration ?? ""
        channelId = video.channelId ?? ""
        channelTitle = video.channelTitle ?? ""
        channelThumbnail = video.channelThumnail ?? ""
        descript = video.descript ?? ""
        thumbnail = video.thumbnail ?? ""
        date = datetime.toString(DateFormat.Date, localized: true)
        time = datetime.toString(DateFormat.Time24NoSec, localized: true)
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
        let historyVideo = History(video)
        RealmManager.addRealm(historyVideo)
    }
}
