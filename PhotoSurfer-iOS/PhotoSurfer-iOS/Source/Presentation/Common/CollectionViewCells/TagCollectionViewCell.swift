//
//  TagCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/12.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    enum TagType {
        case defaultBlueTag /// 파란색
        case deleteEnableBlueTag /// 파란색 + 삭제가능
        case defaultSkyblueTag /// 하늘색
        case selectDisableGrayTag /// 회색
    }

    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteImageViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    func setData(title: String, type: TagType) {
        titleLabel.text = "# " + title
        titleLabel.sizeToFit()
        switch type {
        case .defaultBlueTag:
            backgroundImageView.image = Const.Image.colorMain
            titleLabel.textColor = .white
            deleteImageViewWidthConstraint.constant = 0
        case .deleteEnableBlueTag:
            backgroundImageView.image = Const.Image.colorMain
            titleLabel.textColor = .white
            deleteImageViewWidthConstraint.constant = 16
        case .defaultSkyblueTag:
            backgroundImageView.image = Const.Image.colorSub
            titleLabel.textColor = .pointMain
            deleteImageViewWidthConstraint.constant = 0
        case .selectDisableGrayTag:
            backgroundImageView.image = Const.Image.colorGray
            titleLabel.textColor = .grayGray50
            deleteImageViewWidthConstraint.constant = 0
        }
    }
}
