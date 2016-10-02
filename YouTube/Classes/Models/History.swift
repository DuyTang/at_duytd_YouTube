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
    dynamic var video: Video!
    dynamic var date = ""
    dynamic var time = ""

    required convenience init(_ video: Video) {
        self.init()
        let datetime = NSDate()
        self.video = video
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
