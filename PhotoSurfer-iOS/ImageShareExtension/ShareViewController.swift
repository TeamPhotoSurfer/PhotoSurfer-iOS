//
//  ShareViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/11.
//

import UIKit
import Social

class ShareViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Function
    func setUI() {
        navigationBar.shadowImage = UIImage()
    }
}
