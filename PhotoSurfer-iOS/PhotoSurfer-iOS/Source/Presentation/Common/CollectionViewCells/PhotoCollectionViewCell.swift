//
//  PhotoCollectionViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(image: UIImage) {
        imageView.image = image
    }
    
    func setServerData(imageURL: String, selected: Bool) {
        imageView.setImage(with: imageURL)
        checkImageView.isHidden = !selected
    }
}
