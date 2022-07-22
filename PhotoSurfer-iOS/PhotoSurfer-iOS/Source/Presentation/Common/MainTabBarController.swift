//
//  MainTabBarController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        setTabBar()
    }
    
    private func setTabBar() {
        let appearance = UITabBarAppearance()
        let tabBar = UITabBar()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.grayWhite
        tabBar.standardAppearance = appearance
        tabBar.layer.borderWidth = 0.33
        tabBar.layer.borderColor = UIColor.grayGray40.cgColor
        tabBar.clipsToBounds = false
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
