//
//  SetAlarmViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/17.
//

import UIKit

class SetAlarmViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var commentTimeView: UIView!
    @IBOutlet weak var memoTextView: UITextView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        commentTimeView.isHidden = true
        commentTimeView.layer.cornerRadius = 4
        setTextViewTextStyle()
    }
    
    private func setTextViewTextStyle() {
    }
    
    // MARK: - IBAction
    @IBAction func showCommentTimeButtonDidTap(_ sender: UIButton) {
        commentTimeView.isHidden.toggle()
    }
}
