//
//  SettingViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

class SettingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Function
    
    // MARK: - IBAction
    @IBAction func settingUserButtonDidTap(_ sender: Any) {
        let settingUserStoryboard = UIStoryboard(name: Const.Storyboard.SettingUser, bundle: nil)
        let settingUserViewController = settingUserStoryboard.instantiateViewController(withIdentifier: Const.ViewController.SettingUserViewController)
        self.navigationController?.pushViewController(settingUserViewController, animated: true)
    }
    @IBAction func settingPolicyButtonDidTap(_ sender: Any) {
        let settingPolicyStoryboard = UIStoryboard(name: Const.Storyboard.SettingPolicy, bundle: nil)
        let settingPolicyViewController = settingPolicyStoryboard.instantiateViewController(withIdentifier: Const.ViewController.SettingPolicyViewController)
        self.navigationController?.pushViewController(settingPolicyViewController, animated: true)
    }
    
}
