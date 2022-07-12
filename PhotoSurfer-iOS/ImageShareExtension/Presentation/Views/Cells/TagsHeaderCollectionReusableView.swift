//
//  TagsHeaderCollectionReusableView.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/12.
//

import UIKit

final class TagsHeaderCollectionReusableView: UICollectionReusableView {

    // MARK: - Property
    static let identifier = "TagsHeaderCollectionReusableView"
    
    // MARK: - IBOutlet
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var underSixLabel: UILabel!
    @IBOutlet weak var platformDescriptionLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()

        self.frame.size.height = 200
    }
    
    // MARK: - Function
    func setData(value: String) {
        self.headerLabel.text = value
    }
    
    func setNotInputTagHeader() {
        self.headerLabel.font = UIFont.iosSubtitle2
    }
}
