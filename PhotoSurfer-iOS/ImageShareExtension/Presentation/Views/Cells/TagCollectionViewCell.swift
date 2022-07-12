//
//  TagCollectionViewCell.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/12.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    // MARK: - Property
    static let identifier = "TagCollectionViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagNameLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    func setData(value: String) {
        tagNameLabel.text = value
    }

}
