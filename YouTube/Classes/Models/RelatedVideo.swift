//
//  RelatedVideo.swift
//  YouTube
//
//  Created by Duy Tang on 8/14/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RelatedVideo: Object, Mappable {
    dynamic var idVideo = ""
    dynamic var title = ""
    dynamic var viewCount = ""
    dynamic var duration = ""
    dynamic var channelTitle = ""
    dynamic var descript = ""
    dynamic var thumbnail = ""

    required convenience init(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        var id = [String: AnyObject]()
        id <- map["id"]
        idVideo = id["videoId"] as? String ?? ""
        var snippet = [String: AnyObject]()
        snippet <- map["snippet"]
        title = snippet["title"] as? String ?? ""
        channelTitle = snippet["channelTitle"] as? String ?? ""
        descript = snippet["description"] as? String ?? ""
        thumbnail = AppDefine.UrlImage + idVideo + AppDefine.StandardImage
        // var contentDetails = [String: AnyObject]()
        // contentDetails <- map["contentDetails"]
        // duration = contentDetails["duration"] as? String ?? ""
        //
        // var statistics = [String: AnyObject]()
        // statistics <- map["statistics"]
        // viewCount = statistics["viewCount"] as? String ?? ""

    }
    class func getRelatedVideo() -> Results<RelatedVideo>? {
        do {
            let realm = try Realm()
            let relatedVideo = realm.objects(self)
            return relatedVideo
        } catch {
            return nil
        }
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
}
