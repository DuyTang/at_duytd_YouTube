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

private protocol ValueObject {
    init?(_ object: VideoFavorite)
    init?(history: History)
}

class Video: Object, Mappable, ValueObject {
    dynamic var idVideo = ""
    dynamic var idCategory = ""
    dynamic var title = ""
    dynamic var viewCount = ""
    dynamic var duration = ""
    dynamic var channelTitle = ""
    dynamic var descript = ""
    dynamic var thumbnail = ""

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        var id = ""
        id <- map["id"]
        if id == "" {
            var items = [String: AnyObject]()
            items <- map["id"]
            idVideo = items["videoId"] as? String ?? ""
        } else {
            idVideo = id
        }

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

    class func getVideos(id: String) -> Results<Video>? {
        do {
            let realm = try Realm()
            let videos = realm.objects(self).filter("idCategory = '\(id)'")
            return videos
        } catch {
            return nil
        }
    }

    convenience required init(_ object: VideoFavorite) {
        self.init()
        self.idVideo = object.idVideo ?? ""
        self.idCategory = object.idCategory ?? ""
        self.title = object.title ?? ""
        self.viewCount = object.viewCount ?? ""
        self.duration = object.duration ?? ""
        self.channelTitle = object.channelTitle ?? ""
        self.thumbnail = object.thumbnail ?? ""
        self.descript = object.descript ?? ""
    }
    
    convenience required init(history: History) {
        self.init()
        self.idVideo = history.idVideo ?? ""
        self.idCategory = history.idCategory ?? ""
        self.title = history.title ?? ""
        self.viewCount = history.viewCount ?? ""
        self.duration = history.duration ?? ""
        self.channelTitle = history.channelTitle ?? ""
        self.thumbnail = history.thumbnail ?? ""
        self.descript = history.descript ?? ""
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

