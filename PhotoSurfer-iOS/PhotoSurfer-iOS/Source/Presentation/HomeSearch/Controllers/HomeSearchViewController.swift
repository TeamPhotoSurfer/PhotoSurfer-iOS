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
            tagCell.setData(title: itemIdentifier.title, isInputTag: indexPath.section == 0)
            return tagCell
        })
        dataSource.supplementaryViewProvider = {(collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Identifier.HomeSearchHeaderCollectionReusableView, for: indexPath) as? HomeSearchHeaderCollectionReusableView else { fatalError() }
            header.setData(title: self.collectionViewHeaders[indexPath.section])
            return header
        }
    }
    
   
}

// 이후 삭제할 부분이라 아래에 바로 넣어놓음
extension HomeSearchViewController {
    
    private func setDummy() {
        inputTags = [Tag(title: "input"), Tag(title: "input"), Tag(title: "input"),Tag(title: "input")]
        recentTags = [Tag(title: "recent"), Tag(title: "recent"), Tag(title: "recent"), Tag(title: "recent"), Tag(title: "recent")]
        frequencyTags = [Tag(title: "자주"), Tag(title: "자주"), Tag(title: "자주"), Tag(title: "자주")]
        relatedTags = [Tag(title: "연관"), Tag(title: "연관"), Tag(title: "연관"), Tag(title: "연관"),Tag(title: "연관")
        ]
    }
}
