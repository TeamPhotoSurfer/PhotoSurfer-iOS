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
    @IBOutlet weak var tagNameButton: UIButton!
    @IBOutlet weak var tagStarButton: UIButton!
    
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
            tagStarButton.setImage(Const.Image.leftStarIconYellowButton, for: .normal)
        }
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = Const.Image.icHashtagLineTagWhite
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: album.name))
        tagNameButton.setAttributedTitle(attributedString, for: .normal)
        tagNameButton.titleLabel?.textAlignment = NSTextAlignment.center
        
    }
}
