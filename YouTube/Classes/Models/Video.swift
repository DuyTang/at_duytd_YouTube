//
//  Video.swift
//  YouTube
//
//  Created by Duy Tang on 8/10/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Video: Object, Mappable {
    dynamic var idVideo = ""
    dynamic var idCategory = ""
    dynamic var title = ""
    dynamic var viewCount = ""
    dynamic var duration = ""
    dynamic var channelTitle = ""
    dynamic var descript = ""
    dynamic var thumbnail = ""
    dynamic var isFavorite = false
    dynamic var idListFavorite = ""

    required convenience init(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        idVideo <- map["id"]
        var snippet = [String: AnyObject]()
        snippet <- map["snippet"]
        title = snippet["title"] as? String ?? ""
        channelTitle = snippet["channelTitle"] as? String ?? ""
        descript = snippet["description"] as? String ?? ""

        var contentDetails = [String: AnyObject]()
        contentDetails <- map["contentDetails"]
        duration = contentDetails["duration"] as? String ?? ""

        var statistics = [String: AnyObject]()
        statistics <- map["statistics"]
        viewCount = statistics["viewCount"] as? String ?? ""
        thumbnail = AppDefine.UrlImage + idVideo + AppDefine.StandardImage
    }

    class func getVideos() -> Results<Video>? {
        do {
            let realm = try Realm()
            let videos = realm.objects(self)
            return videos
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

