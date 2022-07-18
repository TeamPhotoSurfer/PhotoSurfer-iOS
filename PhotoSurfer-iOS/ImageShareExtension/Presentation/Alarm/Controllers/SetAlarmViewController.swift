//
//  SetAlarmViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/17.
//

import UIKit

final class SetAlarmViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var commentTimeView: UIView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var settingTimeButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var setRepresentTagButton: UIButton!
    
    // MARK: - Property
    let textViewPlaceHolder: String = "50자 이내로 알림메모를 작성해보세요."
    var keyHeight: CGFloat?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setKeyboard()
    }
    
    // MARK: - Function
    private func setUI() {
        setCommentTimeView()
        setTextView()
        setAlarmButton.layer.cornerRadius = 8
        settingTimeButton.layer.cornerRadius = 8
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    private func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    private func setCommentTimeView() {
        commentTimeView.isHidden = true
        commentTimeView.layer.cornerRadius = 4
    }
    
    private func setTextView() {
        memoTextView.delegate = self
        memoTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        memoTextView.layer.cornerRadius = 8
    }
    
    // MARK: - Objc Function
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if self.view.window?.frame.origin.y != 0 {
                self.view.window?.frame.origin.y = 0
            }
            else {
                self.view.window?.frame.origin.y -= keyboardHeight
            }
        }
        scrollView.scroll(to: .bottom)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
        scrollView.scroll(to: .bottom)
    }
    
    @objc func datePickerChanged() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy. M. dd (EEEEE)"
        dateformatter.locale = Locale(identifier:"ko_KR")
        let date = dateformatter.string(from: datePicker.date)
        settingTimeButton.setTitle(date, for: .normal)
    }
    
    
    // MARK: - IBAction
    @IBAction func showCommentTimeButtonDidTap(_ sender: UIButton) {
        commentTimeView.isHidden.toggle()
    }
    
    @IBAction func setRepresentationTagButtonDidTap(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SetRepresentTag", bundle: nil)
        guard let setRepresentTagViewController = storyboard.instantiateViewController(withIdentifier: "SetRepresentTagViewController") as? SetRepresentTagViewController else {
            return
        }
        self.navigationController?.pushViewController(setRepresentTagViewController, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func showDatePickerButtonDidTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.datePickerView.isHidden.toggle()
        }
    }
}

