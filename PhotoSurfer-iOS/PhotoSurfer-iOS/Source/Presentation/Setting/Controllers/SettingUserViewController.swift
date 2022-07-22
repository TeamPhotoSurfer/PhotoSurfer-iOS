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
        let withdrawTapGesture = UITapGestureRecognizer(target: self, action: #selector(withdrawButtonDidTap))
        withdrawView.isUserInteractionEnabled = true
        withdrawView.addGestureRecognizer(withdrawTapGesture)
    }
    
    func setRootViewController(name: String, identifier: String) {
        let viewController = UIStoryboard(name: name, bundle: nil)
            .instantiateViewController(withIdentifier: identifier)
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        delegate.window?.rootViewController = viewController
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
                self.setRootViewController(name: Const.Storyboard.Login, identifier: Const.ViewController.LoginViewController)
            }
            else {
                print("logout() success.")
                
            }
        }
    }
    
    @objc func withdrawButtonDidTap(sender: UITapGestureRecognizer) {
        self.makeOKAlert(title: nil, message: "서비스 준비 중이에요.")
    }
}
