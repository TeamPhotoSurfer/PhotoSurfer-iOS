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
    var tags: [Tag] = []
    var image: UIImage = UIImage()
    var photoID: Int = 0
    var tagIDs: [Int] = []
    var representTag: [Tag] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setKeyboard()
        postImageNTags(imagefile: image, tags: tags)
    }
    
    // MARK: - Function
    private func setUI() {
        setCommentTimeView()
        setTextView()
        setDatePicker()
        setAlarmButton.layer.cornerRadius = 8
        setTimeButton()
        setLottie()
        setRepresentTag()
    }
    
    private func setDatePicker() {
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.minimumDate = Date()
    }
    
    private func setTimeButton() {
        settingTimeButton.layer.cornerRadius = 8
        settingTimeButton.titleLabel?.numberOfLines = 1
        settingTimeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        settingTimeButton.setTitle(setDateToString(date: Date()), for: .normal)
        settingTimeButton.setTitle(setDateToString(date: datePicker.date), for: .selected)
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.surfingAnimationView.stop()
            self.loadingView.isHidden = true
        }
    }
    
    private func postImageNTags(imagefile: UIImage, tags: [Tag]) {
        let photoRequest: PhotoRequest = PhotoRequest(file: imagefile, tags: tags)
        PhotoService.shared.postPhoto(photoInfo: photoRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data as? Photo else { return }
                self.photoID = data.id
                guard let fetchedTags = data.tags else { return }
                for fetchedTag in fetchedTags {
                    guard let id = fetchedTag.id else {
                        return
                    }
                    self.tagIDs.append(id)
                }
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    private func postPushAlarm(pushAlarm: PushAlarmRequest) {
        let pushAlarmRequest: PushAlarmRequest = pushAlarm
        PushService.shared.postPush(photoID: photoID, pushInfo: pushAlarmRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data as? PostPushResponse else { return }
                print(data.memo)
                self.showDismissAlert(message: "알림이 설정되었습니다.")
            case .requestErr(let status):
                if status as! Int ==  403 {
                    self.showAlert(message: "알림은 내일부터 설정할 수 있어요.")
                }
                else if status as! Int == 409 {
                    self.showAlert(message: "사진에 해당하는 푸시알림이 이미 존재합니다.")
                }
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    private func setRepresentTag() {
        if tags.count > 3 {
            for index in 0..<3 {
                representTag.append(tags[index])
            }
        }
        else {
            representTag = tags
        }
        
        var selectedTagName: String = ""
        for index in 0..<representTag.count {
            switch index {
            case tags.count-1:
                selectedTagName += "#\(tags[index].name)"
            default:
                selectedTagName += "#\(tags[index].name), "
            }
        }
        setRepresentTagButton.setTitle(selectedTagName, for: .normal)
    }
    
    private func setDateToString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy. M. dd (EEEEE)"
        dateformatter.locale = Locale(identifier:"ko_KR")
        let date = dateformatter.string(from: date)
        return date
    }
    
    private func setDateToString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-M-dd"
        dateformatter.locale = Locale(identifier:"ko_KR")
        let date = dateformatter.string(from: datePicker.date)
        return date
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
        setRepresentTagViewController.tags = tags
        self.navigationController?.pushViewController(setRepresentTagViewController, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @IBAction func showDatePickerButtonDidTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.datePickerView.isHidden.toggle()
        }
    }
    @IBAction func saveAlarmButton(_ sender: UIButton) {
        let date = setDateToString()
        var memo: String = ""
        if textViewPlaceHolder != memoTextView.text {
            memo = self.memoTextView.text
        }
        if setDateToString(date: datePicker.date) == setDateToString(date: Date()) {
            showAlert(message: "푸시알림 설정 날짜는 오늘 날짜 이후여야 합니다.")
        }
        else {
            let pushRequest = PushAlarmRequest(memo: memo, pushDate: date, tagIDs: tagIDs)
            postPushAlarm(pushAlarm: pushRequest)
        }
    }
}

