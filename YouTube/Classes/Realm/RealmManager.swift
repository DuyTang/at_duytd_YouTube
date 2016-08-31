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
    class func getListVideo(id: String) -> Results<Video>? {
        return realm?.objects(Video).filter("idCategory = %@", id)
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
