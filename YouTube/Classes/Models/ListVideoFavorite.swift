//
//  ListVideoFavorite.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VideoFavorite: Object {
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
    dynamic var idListFavorite = 0

    class func getVideos(id: String) -> Results<VideoFavorite>? {
        do {
            let realm = try Realm()
            let videos = realm.objects(self).filter("idCategory = %@", id)
            return videos
        } catch {
            return nil
        }
    }

    func initializate(video: Video, idListFavorite: Int) {
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
        timeUpload = video.timeUpload
        self.idListFavorite = idListFavorite
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
