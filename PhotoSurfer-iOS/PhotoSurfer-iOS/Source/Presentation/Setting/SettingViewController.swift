//
//  SettingViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class SettingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userSettingView: UIView!
    @IBOutlet weak var policySettingView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIViewTapAction()
    }
    
    // MARK: - Function
    func setUIViewTapAction() {
        let userSettingTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingUserButtonDidTap))
        let policySettingTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingPolicyButtonDidTap))
        userSettingView.isUserInteractionEnabled = true
        userSettingView.addGestureRecognizer(userSettingTapGesture)
        policySettingView.isUserInteractionEnabled = true
        policySettingView.addGestureRecognizer(policySettingTapGesture)
    }
    
    // MARK: - Objc Function
    @objc func settingUserButtonDidTap(sender: UITapGestureRecognizer) {
        let settingUserStoryboard = UIStoryboard(name: Const.Storyboard.SettingUser, bundle: nil)
        let settingUserViewController = settingUserStoryboard.instantiateViewController(withIdentifier: Const.ViewController.SettingUserViewController)
        self.navigationController?.pushViewController(settingUserViewController, animated: true)
    }
    
    @objc func settingPolicyButtonDidTap(sender: UITapGestureRecognizer) {
        let settingPolicyStoryboard = UIStoryboard(name: Const.Storyboard.SettingPolicy, bundle: nil)
        let settingPolicyViewController = settingPolicyStoryboard.instantiateViewController(withIdentifier: Const.ViewController.SettingPolicyViewController)
        self.navigationController?.pushViewController(settingPolicyViewController, animated: true)
    }
}
