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
    @IBOutlet weak var relatedTagInputView: UIView!
    @IBOutlet weak var relatedTagInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var platformCheckButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        self.frame.size.height = 200
        platformCheckButton.setImage(Const.Image.icCheckCircleFillCheckboxGray40, for: .normal)
        platformCheckButton.setImage(Const.Image.icCheckCircleFillCheckboxMain, for: .selected)
        platformCheckButton.setTitleColor(.grayGray40, for: .normal)
        platformCheckButton.setTitleColor(.pointMain, for: .selected)
        platformCheckButton.setTitle("플랫폼", for: .normal)
        platformCheckButton.setTitle("플랫폼", for: .selected)
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
    
    func setRelatedTagInputView(isRelatedTag: Bool) {
        self.relatedTagInputView.isHidden = !isRelatedTag
        self.relatedTagInputViewHeight.constant = isRelatedTag ? 34 : 0
    }
    
    // MARK: - IBAction
    @IBAction func platformButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
