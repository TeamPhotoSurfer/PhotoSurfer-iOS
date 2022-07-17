//
//  UITextField+.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/17.
//

import UIKit

extension UITextField {
    func addPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
  }
}
