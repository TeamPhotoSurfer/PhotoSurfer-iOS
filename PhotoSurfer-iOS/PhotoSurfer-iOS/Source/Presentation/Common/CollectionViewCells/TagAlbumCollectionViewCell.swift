//
//  TagAlbumCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/14.
//

import UIKit

class TagAlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagBackgroundImage: UIImageView!
    @IBOutlet weak var tagStarImage: UIImageView!
    @IBOutlet weak var tagNameLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    func setDumy(_ album: Album) {
        if album.isMarked {
            tagStarImage.image = Const.Image.leftStarIconYellowButton
        }
        tagNameLabel.text = album.name
    }
}
