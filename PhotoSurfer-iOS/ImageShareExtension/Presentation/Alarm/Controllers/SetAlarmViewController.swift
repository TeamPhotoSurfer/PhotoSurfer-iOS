//
//  SetAlarmViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/17.
//

import UIKit

class SetAlarmViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var commentTimeView: UIView!
    @IBOutlet weak var memoTextView: UITextView!
    
    // MARK: - Property
    let textViewPlaceHolder: String = "50자 이내로 알림메모를 작성해보세요."
    
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
        memoTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        memoTextView.layer.cornerRadius = 8
    }
    
    // MARK: - IBAction
    @IBAction func showCommentTimeButtonDidTap(_ sender: UIButton) {
        commentTimeView.isHidden.toggle()
    }
}
