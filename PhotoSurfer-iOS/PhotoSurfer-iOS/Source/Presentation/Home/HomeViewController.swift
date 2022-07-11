//
//  HomeViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    // MARK: - Function
    private func setUI() {
        setLabelUI()
        setSearchButtonUI()
    }
    
    private func setLabelUI() {
        if let title = titleLabel.text {
            let attributedStr = NSMutableAttributedString(string: title)
            attributedStr.addAttribute(.font, value: UIFont.iosTitle1M, range: (title as NSString).range(of: "어떤 사진을 향해"))
            attributedStr.addAttribute(.font, value: UIFont.iosTitle1B, range: (title as NSString).range(of: "서핑할까요?"))
            titleLabel.attributedText = attributedStr
        }
    }
    
    private func setSearchButtonUI() {
        searchButton.layer.borderColor = UIColor.pointBlue.cgColor
        searchButton.layer.borderWidth = 2
        searchButton.layer.cornerRadius = 22
    }
}
