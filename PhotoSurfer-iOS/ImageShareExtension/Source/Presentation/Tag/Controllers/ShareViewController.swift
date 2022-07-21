//
//  ShareViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/11.
//

import UIKit
import Social

import MobileCoreServices

final class ShareViewController: UIViewController {
    
    // MARK: - Property
    var addedTags: [Tag] = [] {
        willSet {
            saveButton.isEnabled = !newValue.isEmpty
        }
    }
    var recentTags: [Tag] = []
    var oftenTags: [Tag] = []
    var platformTags: [Tag] = []
    let platform = ["카카오톡", "유튜브", "인스타그램", "쇼핑몰", "커뮤니티", "기타"]
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
    var image = UIImage()
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addedTagCollectionView: UICollectionView!
    @IBOutlet weak var typingButton: UIButton!
    @IBOutlet weak var typingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var typingView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFrequencyTag()
        setUI()
        setKeyboard()
        setCollectionView()
        bindData()
        getSelectedImage()
    }
    
    // MARK: - Function
    private func setUI() {
        setSearchBarUI()
        setSearchBar()
        setSaveButton()
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
    
    private func setSaveButton() {
        saveButton.setTitleColor(.pointMain, for: .normal)
        saveButton.setTitleColor(.grayGray60, for: .disabled)
        saveButton.isEnabled = true
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
                if let platform = data.platform {
                    self.platformTags = platform.tags
                    self.relatedTagsFetched += platform.tags
                }
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
    
    private func getSelectedImage() {
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        for items in extensionItems {
            if let itemProviders = items.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                        itemProvider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { result, error in
                            if let url = result as? URL,
                               let data = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    self.image = UIImage(data: data)!
                                }
                            } else {
                                fatalError("Impossible to save image")
                            }
                        })
                    }
                }
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
                if addedTags.isEmpty  {
                    typingViewTopConstraint.constant += 34
                }
                else {
                    typingViewTopConstraint.constant = typingButtonTopConstValue
                }
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
        guard let setAlarmNavigationController = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController, let setAlarmViewController =  setAlarmNavigationController.topViewController as? SetAlarmViewController else {
            return
        }
        for i in 0..<addedTags.count {
            if platform.contains(addedTags[i].name) {
                addedTags[i].tagType = .platform
            }
            else {
                addedTags[i].tagType = .general
            }
        }
        setAlarmViewController.tags = addedTags
        setAlarmViewController.image = image
        self.present(setAlarmNavigationController, animated: true)
    }
}
