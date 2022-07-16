//
//  TagCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/12.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    func setData(title: String, isInputTag: Bool) {
        titleLabel.text = title
        backgroundImageView.image = isInputTag ? Const.Image.colorMain : Const.Image.colorSub
        titleLabel.textColor = isInputTag ? .white : .pointMain
        deleteImageView.isHidden = !isInputTag
        titleLabel.sizeToFit()
    }
}
