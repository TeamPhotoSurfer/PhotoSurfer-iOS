//
//  SettingUserViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/16.
//

import UIKit

import KakaoSDKUser

class SettingUserViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var withdrawView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: - Function
    func setUI() {
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutButtonDidTap))
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(logoutTapGesture)
    }

    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Objc Function
    @objc func logoutButtonDidTap(sender: UITapGestureRecognizer) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
}
