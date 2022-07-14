//
//  UIViewController+.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/13.
//

import UIKit

extension UIViewController {
    
    // MARK: - Function
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
