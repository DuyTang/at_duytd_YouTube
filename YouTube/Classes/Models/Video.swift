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

    class func getVideos(id: String) -> Results<Video>? {
        do {
            let realm = try Realm()
            let videos = realm.objects(self).filter("idCategory = '\(id)'")
            return videos
        } catch {
            return nil
        }
    }

    func initializate(favoriteVideo: VideoFavorite) {
        self.idVideo = favoriteVideo.idVideo ?? ""
        self.idCategory = favoriteVideo.idCategory ?? ""
        self.title = favoriteVideo.title ?? ""
        self.viewCount = favoriteVideo.viewCount ?? ""
        self.duration = favoriteVideo.duration ?? ""
        self.channelTitle = favoriteVideo.channelTitle ?? ""
        self.thumbnail = favoriteVideo.thumbnail ?? ""
        self.descript = favoriteVideo.descript ?? ""
    }

    func initFromRelatedVideo(relatedVideo: RelatedVideo) {
        self.idVideo = relatedVideo.idVideo ?? ""
        self.title = relatedVideo.title ?? ""
        self.viewCount = relatedVideo.viewCount ?? ""
        self.duration = relatedVideo.duration ?? ""
        self.channelTitle = relatedVideo.channelTitle ?? ""
        self.thumbnail = relatedVideo.thumbnail ?? ""
        self.descript = relatedVideo.descript ?? ""
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

