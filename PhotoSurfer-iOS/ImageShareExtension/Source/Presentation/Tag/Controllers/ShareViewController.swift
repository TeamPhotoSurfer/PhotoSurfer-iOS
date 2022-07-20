//
//  ShareViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/11.
//

import UIKit
import Social

final class ShareViewController: UIViewController {
    
    // MARK: - Property
    var addedTags: [Tag] = []
    var recentTags: [Tag] = []
    var oftenTags: [Tag] = []
    var platformTags: [Tag] = [Tag(name: "카카오톡"), Tag(name: "유튜브"), Tag(name: "인스타그램"), Tag(name: "쇼핑몰"), Tag(name: "커뮤니티"), Tag(name: "기타")]
    var relatedTags: [Tag] = []
    var relatedTagsFetched: [Tag] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>! = nil
    let headerTitleArray: [String] = ["추가한 태그", "최근 추가한 태그", "자주 추가한 태그", "플랫폼 유형", "연관 태그"]
    let searchHeaderTitleArray: [String] = ["추가한 태그", ""]
    var typingText: String = ""
    var isTyping: Bool = false
    var typingTextCount: Int = 0
    enum Section: Int {
        case addedTag
        case recentTag
        case oftenTag
        case platformTag
        case relatedTag
    }
    let underSixTagMessage: String = "태그는 최대 6개까지만 추가할 수 있어요."
    let alreadyAddedMessage: String = "이미 같은 태그를 추가했어요."
    let typingButtonTopConstValue: CGFloat = -95
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addedTagCollectionView: UICollectionView!
    @IBOutlet weak var typingButton: UIButton!
    @IBOutlet weak var typingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var typingView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFrequencyTag()
        setUI()
        setKeyboard()
        setCollectionView()
        bindData()
    }
    
    // MARK: - Function
    private func setUI() {
        setSearchBarUI()
        setSearchBar()
        registerXib()
        setHierarchy(isSearching: false)
        self.isModalInPresentation = true
    }
    
    private func registerXib() {
        addedTagCollectionView.register(UINib(nibName: TagCollectionViewCell.identifier, bundle: nil),
                                        forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        addedTagCollectionView.register(UINib(nibName: TagsHeaderCollectionReusableView.identifier, bundle: nil),
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TagsHeaderCollectionReusableView.identifier)
    }
    
    private func setCollectionView() {
        addedTagCollectionView.delegate = self
    }
    
    private func bindData() {
        setSupplementaryViewProvider(dataSource: setDataSource())
    }
    
    private func setKeyboard() {
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setSearchBar() {
        searchBar.delegate = self
    }
    
    private func setSearchBarUI() {
        searchBar.layer.cornerRadius = 8
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.font = .iosBody2
        searchBar.placeholder = "태그를 입력하세요"
        searchBar.inputAccessoryView = setToolbar()
    }
    
    private func setToolbar() -> UIToolbar {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(self.doneButtonDidTap))
        toolBarKeyboard.items = [flexibleSpaceButton, doneButton]
        return toolBarKeyboard
    }
    
    private func getFrequencyTag() {
        TagService.shared.getTagMain { result in
            switch result {
            case .success(let data):
                guard let data = data as? TagMainResponse else { return }
                self.recentTags = data.recent.tags
                self.relatedTagsFetched += data.recent.tags
                self.oftenTags = data.often.tags
                self.relatedTagsFetched += data.often.tags
                self.relatedTagsFetched += self.platformTags
                self.applyInitialDataSource()
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
    
    // MARK: - Objc Function
    @objc private func doneButtonDidTap() {
        dismissKeyboard()
    }
    
    // MARK: - Objc Function
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if collectionViewBottonConstraint.constant != 0 {
                collectionViewBottonConstraint.constant = 0
                typingViewTopConstraint.constant = typingButtonTopConstValue
            }
            else {
                collectionViewBottonConstraint.constant += keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if collectionViewBottonConstraint.constant != 0 {
            collectionViewBottonConstraint.constant = 0
            typingViewTopConstraint.constant = typingButtonTopConstValue
        }
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SetAlarm", bundle: nil)
        guard let setAlarmViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController else {
            return
        }
        self.present(setAlarmViewController, animated: true)
    }
}
