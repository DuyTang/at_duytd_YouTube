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

private protocol VideoObject {
    init?(_ object: VideoFavorite)
    init?(history: History)
}

class Video: Object, Mappable, VideoObject {
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
    dynamic var timeUpload = ""

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        var id = ""
        id <- map["id"]
        if id == "" {
            idVideo <- map["id.videoId"]
        } else {
            idVideo = id
        }
        title <- map["snippet.title"]
        channelId <- map["snippet.channelId"]
        channelTitle <- map["snippet.channelTitle"]
        descript <- map["snippet.description"]
        timeUpload <- map["snippet.publishedAt"]
        thumbnail <- map["snippet.thumbnails.medium.url"]
        duration <- map["contentDetails.duration"]
        viewCount <- map["statistics.viewCount"]
    }

    class func getVideos(id: String) -> Results<Video>? {
        do {
            let realm = try Realm()
            let videos = realm.objects(self).filter("idCategory = %@", id)
            return videos
        } catch {
            return nil
        }
    }

    convenience required init(_ object: VideoFavorite) {
        self.init()
        idVideo = object.video.idVideo ?? ""
        idCategory = object.video.idCategory ?? ""
        title = object.video.title ?? ""
        viewCount = object.video.viewCount ?? ""
        duration = object.video.duration ?? ""
        channelId = object.video.channelId ?? ""
        channelTitle = object.video.channelTitle ?? ""
        channelThumbnail = object.video.channelThumbnail ?? ""
        thumbnail = object.video.thumbnail ?? ""
        descript = object.video.descript ?? ""
        timeUpload = object.video.timeUpload
    }

    convenience required init(history: History) {
        self.init()
        idVideo = history.video.idVideo ?? ""
        idCategory = history.video.idCategory ?? ""
        title = history.video.title ?? ""
        viewCount = history.video.viewCount ?? ""
        duration = history.video.duration ?? ""
        channelId = history.video.channelId ?? ""
        channelTitle = history.video.channelTitle ?? ""
        channelThumbnail = history.video.channelThumbnail ?? ""
        thumbnail = history.video.thumbnail ?? ""
        descript = history.video.descript ?? ""
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

