//
//  HomeSearchViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/12.
//

import UIKit

struct Tag: Hashable {
    // 추후 없앨예정
    let uuid = UUID()
    let title: String
}

final class HomeSearchViewController: UIViewController {
    
    enum Section: Int {
        case inputTag
        case recentAddTag
        case frequencyAddTag
        case relatedTag
    }
    
    // MARK: - Property
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var inputTags: [Tag] = []
    var recentTags: [Tag] = []
    var frequencyTags: [Tag] = []
    var relatedTags: [Tag] = []
    var collectionViewHeaders: [String] = []
    var isShownRelated: Bool = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDummy()
        setUI()
        setCollectionView()
        setSearchBarDelegate()
        setKeyboardToolBar()
    }
    
    // MARK: - Function
    private func setUI() {
        setSearchBarUI()
    }
    
    private func setSearchBarUI() {
        searchBar.layer.cornerRadius = 8
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.font = .iosBody2
        searchBar.backgroundColor = .grayGray10
        searchBar.searchTextField.backgroundColor = .clear
    }
    
    private func setSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    private func setCollectionView() {
        registerXib()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource()
        applyInitialDataSource()
        collectionView.delegate = self
    }
    
    private func registerXib() {
        collectionView.register(UINib(nibName: Const.Identifier.TagCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: Const.Identifier.TagCollectionViewCell)
        collectionView.register(UINib(nibName: Const.Identifier.HomeSearchHeaderCollectionReusableView, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Identifier.HomeSearchHeaderCollectionReusableView)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else { fatalError() }
            tagCell.setData(title: itemIdentifier.title, type: indexPath.section == 0 ? .deleteEnableBlueTag : .defaultSkyblueTag)
            return tagCell
        })
        dataSource.supplementaryViewProvider = {(collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Identifier.HomeSearchHeaderCollectionReusableView, for: indexPath) as? HomeSearchHeaderCollectionReusableView else { fatalError() }
            header.setData(title: self.collectionViewHeaders[indexPath.section])
            return header
        }
    }
    
    private func setKeyboardToolBar() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(self.closeKeyboard))
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace, closeButton], animated: false)
        searchBar.inputAccessoryView = toolbar
    }
    
    func goToSearchResultViewController(tags: [Tag] = []) {
        guard let resultViewController = UIStoryboard(name: Const.Storyboard.HomeResult, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.HomeResultViewController) as? HomeResultViewController else { return }
        resultViewController.tags = tags
        resultViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    // MARK: - Objc Function
    @objc private func closeKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// 이후 삭제할 부분이라 아래에 바로 넣어놓음
extension HomeSearchViewController {
    
    private func setDummy() {
        recentTags = [Tag(title: "recent"), Tag(title: "recent"), Tag(title: "recent"), Tag(title: "recent"), Tag(title: "recent")]
        frequencyTags = [Tag(title: "자주"), Tag(title: "자주"), Tag(title: "자주"), Tag(title: "자주")]
        relatedTags = [Tag(title: "연관"), Tag(title: "연관"), Tag(title: "연관"), Tag(title: "연관"),Tag(title: "연관")
        ]
    }
}
