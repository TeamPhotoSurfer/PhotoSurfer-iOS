//
//  AlarmDetailViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/18.
//

import UIKit

final class AlarmDetailViewController: UIViewController {
    
    // MARK: - Property
    var pushID: Int = 1

    // MARK: - IBOutlet
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCyele
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getPushDetail(id: pushID)
    }
    
    // MARK: - Function
    private func setUI() {
        dateButton.layer.cornerRadius = 8
        completeButton.layer.cornerRadius = 8
        memoTextView.layer.cornerRadius = 8
        memoTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private func getPushDetail(id: Int) {
        PushService.shared.getPush(id: id) { response in
            switch response {
            case .success(let data):
                print(data)
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
    
    // MARK: - IBAction
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setDateButtonDidTap(_ sender: Any) {
        self.makeOKAlert(title: "", message: "서비스 준비중입니다.", okAction: nil, completion: nil)
    }
    
    @IBAction func setMainTagButtonDidTap(_ sender: Any) {
        self.makeOKAlert(title: "", message: "서비스 준비중입니다.", okAction: nil, completion: nil)
    }
    
    @IBAction func completeButtonDidTap(_ sender: Any) {
        self.makeOKAlert(title: "", message: "서비스 준비중입니다.", okAction: nil, completion: nil)
    }
}
