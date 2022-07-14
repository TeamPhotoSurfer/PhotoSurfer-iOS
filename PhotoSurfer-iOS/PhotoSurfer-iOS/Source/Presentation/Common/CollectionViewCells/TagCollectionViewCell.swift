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
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    func setData(title: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
    }
}
