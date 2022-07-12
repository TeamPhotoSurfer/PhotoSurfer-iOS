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
    @IBOutlet weak var tagNameLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    // MARK: - Function
    func setData(value: String) {
        tagNameLabel.text = value
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .pointSub
    }
}
