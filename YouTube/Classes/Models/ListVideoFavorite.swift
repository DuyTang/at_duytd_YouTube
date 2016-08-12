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

class ListVideoFavorite: Object {
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

    class func getVideos(id: String) -> Results<ListVideoFavorite>? {
        do {
            let realm = try Realm()
            let videos = realm.objects(self).filter("idCategory = '\(id)'")
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
