//
//  SetRepresentTagViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/17.
//

import UIKit

class SetRepresentTagViewController: UIViewController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func svaeButtonDidTap(_ sender: UIButton) {
    }
}
