//
//  FavoriteCell.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteCell: BaseTableViewCell {

    @IBOutlet weak private var thumbnailFavoriteList: UIImageView!

    @IBOutlet weak private var nameFavoriteListLabel: UILabel!
    @IBOutlet weak private var numberVideoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureFavoriteCell(favorite: Favorite) {
        self.nameFavoriteListLabel.text = favorite.name
        if favorite.numberVideo > 1 {
            self.numberVideoLabel.text = String(favorite.numberVideo) + " videos"
        } else {
            self.numberVideoLabel.text = String(favorite.numberVideo) + " video"
        }
        self.thumbnailFavoriteList.downloadImage(selectImageFavorite(String(favorite.id)))
    }

    override func setUpUI() {

    }

    func selectImageFavorite(idFavorite: String) -> String {
        var thumbnailFavorite: String?
        do {
            let realm = try Realm()
            let video = realm.objects(ListVideoFavorite).filter("idListFavorite = '\(idFavorite)'").first
            thumbnailFavorite = video!.thumbnail
        } catch {

        }
        return thumbnailFavorite!
    }
}
