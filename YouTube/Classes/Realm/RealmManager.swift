//
//  RealmManager.swift
//  YouTube
//
//  Created by Duy Tang on 8/31/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static let realm = try? Realm()

    class func getAllFavorite() -> Results<Favorite>? {
        return realm?.objects(Favorite)
    }
    class func getAllCategory() -> Results<Category>? {
        return realm?.objects(Category)
    }
    class func getAllHistory() -> Results<History>?{
        return realm?.objects(History)
    }
    
    class func getAllObject(ob: Object) -> Results<Object>?{
        return realm?.objects(Object)
    }

    class func getListVideo(id: String) -> Results<Video>? {
        return realm?.objects(Video).filter("idCategory = %@", id)
    }
    class func getListVideoFavorite(key: String) -> Results<VideoFavorite>? {
        return realm?.objects(VideoFavorite).filter("idVideo = %@", key)
    }

    class func getVideoFavorite(key: String) -> VideoFavorite {
        return (realm?.objects(VideoFavorite).filter("idVideo = %@", key).first)!
    }

    class func addRealm(object: Object) {
        do {
            try realm?.write({
                realm?.add(object)
            })
        } catch { }
    }

    class func deleteRealm(object: Object) {
        do {
            try realm?.write({
                realm?.delete(object)
            })
        } catch { }
    }
}
