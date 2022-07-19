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
    @IBOutlet weak var tagDarkView: UIView!
    @IBOutlet weak var tagNameButton: UIButton!
    @IBOutlet weak var tagStarButton: UIButton!
    @IBOutlet weak var tagMenuButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tagDeleteButton: UIButton!
    @IBOutlet weak var tagEditButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    // MARK: - Function
    func setUI() {
        setCellUI()
        setMenuUI()
    }
    
    func setCellUI() {
        tagBackgroundImageView.layer.cornerRadius = 8
        tagDarkView.layer.cornerRadius = 8
        tagStarButton.setImage(Const.Image.leftStarIconYellowButton, for: .selected)
        tagStarButton.setImage(Const.Image.leftStarIconWhiteButton, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(closeMenu), name: Notification.Name("CellTouch"), object: nil)
    }
    
    func setMenuUI() {
        menuView.layer.cornerRadius = 4
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.12
        menuView.layer.shadowRadius = 4
        menuView.layer.shadowOffset = CGSize(width: 0, height: 4)
        menuView.layer.shadowPath = nil
    }
    
    func setDummy(album: Album) {
        tagStarButton.isSelected = album.isMarked
        setTagName(button: tagNameButton, name: album.name)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.superview {
            menuView.isHidden = true
        }
    }
    
    // MARK: - Objc Function
    @objc func closeMenu(notification: NSNotification) {
        self.menuView.isHidden = true
    }
        
    // MARK: - IBAction
    @IBAction func menuButtonDidTap(_ sender: Any) {
        menuView.isHidden.toggle()
    }
    
    @IBAction func starButtonDidTap(_ sender: Any) {
        tagStarButton.isSelected.toggle()
    }
}
