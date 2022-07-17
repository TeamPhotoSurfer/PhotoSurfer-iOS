//
//  PictureViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

final class PictureViewController: UIViewController {
    
    // MARK: - Property
    let photo = Const.Image.imgSea
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageData()
    }
    
    // MARK: - Function
    private func setImageData() {
        imageView.image = photo
        scrollViewHeight.priority = UILayoutPriority(photo.size.height <= photo.size.width ? 1000 : 250)
    }
}
