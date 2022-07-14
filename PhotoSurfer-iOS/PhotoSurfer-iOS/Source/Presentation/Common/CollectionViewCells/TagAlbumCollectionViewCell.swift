//
//  TagAlbumCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/14.
//

import UIKit

final class TagAlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    var menuItems: [UIAction] {
        return [
            UIAction(title: "태그 삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                print("태그 삭제")
            }),
            UIAction(title: "태그 수정", image: UIImage(systemName: "pencil"), handler: { _ in
                print("태그 수정")
            })
        ]
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagBackgroundImageView: UIImageView!
    @IBOutlet weak var tagNameButton: UIButton!
    @IBOutlet weak var tagStarButton: UIButton!
    @IBOutlet weak var tagMoreButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellUI()
        setMoreButton()
    }
    
    // MARK: - Function
    func setCellUI() {
        self.layer.cornerRadius = 8
        tagStarButton.setImage(Const.Image.leftStarIconYellowButton, for: .selected)
        tagStarButton.setImage(Const.Image.leftStarIconWhiteButton, for: .normal)
    }
    
    func setMoreButton() {
        tagMoreButton.menu = UIMenu(
            title: "",
            options: [],
            children: menuItems)
        tagMoreButton.showsMenuAsPrimaryAction = true
    }
    
    func setDummy(_ album: Album) {
        if album.isMarked {
            tagStarButton.isSelected = true
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
