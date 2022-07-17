//
//  SettingUserViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/16.
//

import UIKit

class SettingUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
