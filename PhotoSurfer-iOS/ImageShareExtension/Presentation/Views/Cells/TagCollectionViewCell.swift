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
       // tagNameButton.titleLabel?.text = value
        tagNameButton.setTitle(value, for: .normal)
    }
    
    func setColorNLayout(isAddedTag: Bool) {
        deleteImageView.isHidden = !isAddedTag
        if isAddedTag {
            backgroundImageButton.tintColor = UIColor.pointMain
            tagNameButton.titleLabel?.textColor = .grayWhite
        }
        else {
            backgroundImageButton.tintColor = UIColor.pointSub
            tagNameButton.titleLabel?.textColor = .pointMain
        }
    }
    
    private func setUI() {
    }
}
