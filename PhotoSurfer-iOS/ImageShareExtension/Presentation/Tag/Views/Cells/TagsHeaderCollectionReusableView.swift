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

        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
    }
    
    func setData(value: String) {
        self.headerLabel.text = value
    }
    
    func setNotInputTagHeader() {
        self.underSixLabel.isHidden = true
        self.headerLabel.font = UIFont.iosSubtitle2
    }
    
    func setInputTagHeader() {
        self.underSixLabel.isHidden = false
        self.headerLabel.font = UIFont.iosSubtitle1
    }
}
