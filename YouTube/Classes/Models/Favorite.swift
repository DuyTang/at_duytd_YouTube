//
//  Favorite.swift
//  YouTube
//
//  Created by Duy Tang on 8/11/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    dynamic var id = 0
    dynamic var name = ""
    var listVideo = List<VideoFavorite>()
    class func getId() -> Int {
        var id = 0
        do {
            let realm = try Realm()
            if realm.objects(Favorite).count > 0 {
                id = realm.objects(Favorite).last!.id
            }
        } catch {
        }
        return id
    }

}
