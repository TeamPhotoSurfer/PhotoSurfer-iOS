//
//  UIButton+.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/19.
//

import UIKit

extension UIButton {
    func setTagName(name: String) {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = Const.Image.icHashtagLineTagWhite
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: name))
        self.setAttributedTitle(attributedString, for: .normal)
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
}
