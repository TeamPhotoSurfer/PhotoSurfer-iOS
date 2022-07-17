//
//  UITextView+.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/18.
//

import UIKit

extension UITextField {
    func setLeftPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
