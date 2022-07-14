//
//  TagAlbumCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/14.
//

import UIKit

final class TagAlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagBackgroundImageView: UIImageView!
    @IBOutlet weak var tagStarImageView: UIImageView!
    @IBOutlet weak var tagNameLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellUI()
    }
    
    // MARK: - Function
    func setCellUI() {
        self.layer.cornerRadius = 8
    }
    
    func setDummy(_ album: Album) {
        if album.isMarked {
            tagStarImageView.image = Const.Image.leftStarIconYellowButton
        }
        tagNameLabel.text = album.name
    }
}
