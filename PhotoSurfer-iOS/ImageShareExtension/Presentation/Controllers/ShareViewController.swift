//
//  ShareViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/11.
//

import UIKit
import Social

import Toast_Swift

struct Tag: Hashable {
    // 추후 없앨예정
    let uuid = UUID()
    let title: String
}

final class ShareViewController: UIViewController {
    
    // MARK: - Property
    var addedTags: [Tag] = []
    var recentTags: [Tag] = []
    var oftenTags: [Tag] = []
    var platformTags: [Tag] = []
    var relatedTags: [Tag] = []
    var relatedTagsFetched: [Tag] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>! = nil
    let headerTitleArray: [String] = ["추가한 태그", "최근 추가한 태그", "자주 추가한 태그", "플랫폼 유형", "연관 태그"]
    let searchHeaderTitleArray: [String] = ["추가한 태그", "연관 태그"]
    var typingText: String = ""
    var isTyping: Bool = false {
        willSet(newValue) {
            print(newValue)
        }
    }
    var typingTextCount: Int = 0
    enum Section: Int {
        case addedTag
        case recentTag
        case oftenTag
        case platformTag
        case relatedTag
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addedTagCollectionView: UICollectionView!
    @IBOutlet weak var typingButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDummy()
        setKeyboard()
        bindData()
        setCollectionView()
    }
    
    // MARK: - Function
    private func setUI() {
        setSearchBarUI()
        setSearchBar()
        registerXib()
        setHierarchy()
        typingButton.isHidden = true
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
    
    // MARK: - Objc Function
    @objc private func doneButtonDidTap() {
        dismissKeyboard()
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        self.view.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
    }
}

// 이후 삭제할 부분이라 아래에 바로 넣어놓음
extension ShareViewController {
    private func setDummy() {
        addedTags = [Tag(title: "a"), Tag(title: "b"), Tag(title: "c"),Tag(title: "d")]
        recentTags = [Tag(title: "k"), Tag(title: "kk"), Tag(title: "kkk"), Tag(title: "kkkk"), Tag(title: "kkkkk")]
        oftenTags = [Tag(title: "좋은노래"), Tag(title: "솝트"), Tag(title: "전시회"), Tag(title: "그래픽디자인"), Tag(title: "포토서퍼")]
        platformTags = [Tag(title: "포토서퍼"), Tag(title: "카페"), Tag(title: "위시리스트"), Tag(title: "휴학계획"), Tag(title: "여행")]
        relatedTags = [Tag(title: "avdsdaf"), Tag(title: "sdfds"), Tag(title: "fdsds"), Tag(title: "ssss")]
        relatedTagsFetched = [Tag(title: "avdsdaf"), Tag(title: "sdfds"), Tag(title: "fdsds"), Tag(title: "ssss")]
    }
}
