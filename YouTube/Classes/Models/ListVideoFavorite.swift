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
    dynamic var video: Video!
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
        self.video = video
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
