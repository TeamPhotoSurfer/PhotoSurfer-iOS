//
//  HomeSearchHeaderCollectionReusableView.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/15.
//

import UIKit

final class HomeSearchHeaderCollectionReusableView: UICollectionReusableView {

    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    func setData(title: String) {
        titleLabel.text = title
        conditionLabel.isHidden = !(title == "입력한 태그")
    }
}
