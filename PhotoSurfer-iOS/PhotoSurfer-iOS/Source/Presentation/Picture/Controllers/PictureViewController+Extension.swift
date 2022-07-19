//
//  PictureViewController+Extension.swift
//  PhotoSurfer-iOS
//xx
//  Created by 김혜수 on 2022/07/19.
//

import UIKit

extension PictureViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty ?? true) && tags.count < 6 {
            tags.insert(Tag(title: textField.text ?? ""), at: 0)
            applyTagsSnapshot()
        }
        return true
    }
}
