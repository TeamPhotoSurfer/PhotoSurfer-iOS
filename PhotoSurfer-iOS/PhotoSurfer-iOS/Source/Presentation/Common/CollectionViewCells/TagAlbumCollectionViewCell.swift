//
//  TagAlbumCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/14.
//

import UIKit

protocol MenuHandleDelegate {
    func deleteButtonDidTap(button: UIButton)
    func editButtonDidTap(button: UIButton)
}

final class TagAlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    var delegate: MenuHandleDelegate?
    var menuItems: [UIAction] {
        return [
            UIAction(title: "태그 삭제", image: UIImage(systemName: "trash"), handler: { [self] _ in
                print("태그 삭제")
                self.delegate?.deleteButtonDidTap(button: tagMenuButton)
                
            }),
            UIAction(title: "태그 수정", image: UIImage(systemName: "pencil"), handler: { [self] _ in
                print("태그 수정")
                self.delegate?.editButtonDidTap(button: tagMenuButton)
            })
        ]
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagBackgroundImageView: UIImageView!
    @IBOutlet weak var tagDarkView: UIView!
    @IBOutlet weak var tagNameButton: UIButton!
    @IBOutlet weak var tagStarButton: UIButton!
    @IBOutlet weak var tagMenuButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        setCellUI()
//        setMoreButton()
    }
    
    private func setCellUI() {
        tagBackgroundImageView.layer.cornerRadius = 8
        tagDarkView.layer.cornerRadius = 8
        tagStarButton.setImage(Const.Image.leftStarIconYellowButton, for: .selected)
        tagStarButton.setImage(Const.Image.leftStarIconWhiteButton, for: .normal)
    }
    
    func setMoreButton() {
        tagMenuButton.menu = UIMenu(
            title: "",
            options: [],
            children: menuItems)
        tagMenuButton.showsMenuAsPrimaryAction = true
    }
    
    func setDummy(album: Album) {
        tagStarButton.isSelected = album.isMarked
        tagNameButton.setTagName(name: album.name)
        if album.isPlatform {
            tagMenuButton.menu = UIMenu(
                title: "",
                options: [],
                children: [menuItems[0]])
            tagMenuButton.showsMenuAsPrimaryAction = true
        } else {
            tagMenuButton.menu = UIMenu(
                title: "",
                options: [],
                children: menuItems)
            tagMenuButton.showsMenuAsPrimaryAction = true
        }
    }
    
    // TODO: UIButton extension으로 만들어줘도 좋을 것 같다
    func setTagName(button: UIButton, name: String) {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = Const.Image.icHashtagLineTagWhite
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: name))
        button.setAttributedTitle(attributedString, for: .normal)
        tagNameButton.titleLabel?.textAlignment = NSTextAlignment.center
    }
        
    // MARK: - IBAction
    @IBAction func menuButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func starButtonDidTap(_ sender: Any) {
        tagStarButton.isSelected.toggle()
    }
}
