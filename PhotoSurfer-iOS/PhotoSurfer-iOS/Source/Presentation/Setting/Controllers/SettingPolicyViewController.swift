//
//  SettingPolicyViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/16.
//

import UIKit

class SettingPolicyViewController: UIViewController {

    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var licenseView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    // MARK: - Function
    private func setUI() {
        let policyTapGesture = UITapGestureRecognizer(target: self, action: #selector(alertPreparefunc))
        let licenseTapGesture = UITapGestureRecognizer(target: self, action: #selector(alertPreparefunc))
        policyView.isUserInteractionEnabled = true
        policyView.addGestureRecognizer(policyTapGesture)
        licenseView.isUserInteractionEnabled = true
        licenseView.addGestureRecognizer(licenseTapGesture)
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Objc Function
    @objc func alertPreparefunc(sender: UITapGestureRecognizer) {
        self.makeOKAlert(title: nil, message: "서비스 준비 중이에요.")
    }
}
