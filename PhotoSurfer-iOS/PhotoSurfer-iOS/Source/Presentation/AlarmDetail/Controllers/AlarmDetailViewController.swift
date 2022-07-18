//
//  AlarmDetailViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/18.
//

import UIKit

final class AlarmDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - LifeCyele
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        dateButton.layer.cornerRadius = 8
        completeButton.layer.cornerRadius = 8
        memoTextView.layer.cornerRadius = 8
        memoTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    // MARK: - IBAction
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonDidTap(_ sender: Any) {
    }
}
