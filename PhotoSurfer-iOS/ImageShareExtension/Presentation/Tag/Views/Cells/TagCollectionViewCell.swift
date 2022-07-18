//
//  TagCollectionViewCell.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/12.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    // MARK: - Property
    static let identifier = "TagCollectionViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagNameButton: UIButton!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var backgroundImageButton: UIButton!
    
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setUI()
    }
    
    // MARK: - Function
    func setData(value: String) {
        tagNameButton.setTitle(value, for: .normal)
    }
    
    func setUI(isAddedTag: Bool) {
        deleteImageView.isHidden = !isAddedTag
        if isAddedTag {
            backgroundImageButton.setBackgroundImage(Const.Image.colorMain, for: .normal)
            backgroundImageButton.tintColor = UIColor.pointMain
            tagNameButton.setTitleColor(.grayWhite, for: .normal)
            tagNameButton.tintColor = .grayWhite
        }
        else {
            backgroundImageButton.setBackgroundImage(Const.Image.colorSub, for: .normal)
            backgroundImageButton.tintColor = UIColor.pointSub
            tagNameButton.setTitleColor(.pointMain, for: .normal)
            tagNameButton.tintColor = .pointMain
        }
    }
    
    func setClickedTagUI(isAdded: Bool) {
        if isAdded {
            backgroundImageButton.setBackgroundImage(Const.Image.colorGray, for: .normal)
            backgroundImageButton.tintColor = UIColor.grayGray10
            tagNameButton.setTitleColor(.grayGray70, for: .normal)
            tagNameButton.tintColor = .grayGray70
            self.isUserInteractionEnabled = !isAdded
        }
        else {
            setUI(isAddedTag: false)
            self.isUserInteractionEnabled = true
        }
    }
    
    private func setUI() {
    }
}
