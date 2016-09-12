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
    override func setUpUI() {

    }

    func configureFavoriteCell(favorite: Favorite) {
        self.nameFavoriteListLabel.text = favorite.name
        let numberVideo = getNumberVideo(favorite.id)
        if numberVideo > 1 {
            self.numberVideoLabel.text = String(numberVideo) + " videos"
        } else {
            self.numberVideoLabel.text = String(numberVideo) + " video"
        }
        if selectImageFavorite(favorite.id) == "" {
            self.thumbnailFavoriteList.image = UIImage(named: "bg_video")
        } else {
            self.thumbnailFavoriteList.downloadImage(selectImageFavorite(favorite.id))
        }

    }

    private func getNumberVideo(idListFavorite: Int) -> Int {
        var count = 0
        do {
            let realm = try Realm()
            let listVideo = realm.objects(VideoFavorite).filter("idListFavorite = %@", idListFavorite)
            count = listVideo.count
        } catch {

        }
        return count
    }

    private func selectImageFavorite(idFavorite: Int) -> String {
        var thumbnailFavorite: String = ""
        do {
            let realm = try Realm()
            let videos = realm.objects(VideoFavorite).filter("idListFavorite = %@", idFavorite)
            if videos.count > 0 {
                thumbnailFavorite = videos[0].thumbnail
            } else {
                thumbnailFavorite = ""
            }
        } catch {

        }
        return thumbnailFavorite
    }
}
