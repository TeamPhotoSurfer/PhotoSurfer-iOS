//
//  SetAlarmViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/17.
//

import UIKit

import Lottie

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
    @IBOutlet weak var alarmSaveView: UIView!
    @IBOutlet weak var bellView: UIView!
    @IBOutlet weak var surfingView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Property
    let textViewPlaceHolder: String = "50자 이내로 알림메모를 작성해보세요."
    var keyHeight: CGFloat?
    let bellAnimationView = AnimationView()
    let surfingAnimationView = AnimationView()
    var keyboardShowedCount: Int = 0
    
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
        setLottie()
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
    
    private func setLottie() {
        bellAnimationView.frame = bellView.bounds
        bellAnimationView.animation = Animation.named("bell")
        bellAnimationView.loopMode = .loop
        bellAnimationView.play()
        bellView.addSubview(bellAnimationView)
        
        surfingAnimationView.frame = surfingView.bounds
        surfingAnimationView.animation = Animation.named("surfing")
        surfingAnimationView.loopMode = .loop
        surfingAnimationView.play()
        surfingView.addSubview(surfingAnimationView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.surfingAnimationView.stop()
            self.loadingView.isHidden = true
        }
    }
    
    // MARK: - Objc Function
    @objc func keyboardWillShow(_ sender: Notification) {
        keyboardShowedCount += 1
        if keyboardShowedCount == 1 {
            if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.window?.frame.origin.y -= keyboardHeight - (datePickerView.isHidden ? 100 : 16)
                alarmSaveView.isHidden = true
            }
            scrollView.scroll(to: .bottom)
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        keyboardShowedCount = 0
        alarmSaveView.isHidden = false
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
        setRepresentTagViewController.delegate = self
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

