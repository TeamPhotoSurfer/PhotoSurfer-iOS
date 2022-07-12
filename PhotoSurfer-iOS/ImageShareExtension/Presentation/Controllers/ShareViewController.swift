//
//  ShareViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/11.
//

import Social
import UIKit

final class ShareViewController: UIViewController {
    
    // MARK: - Property
    var addedTags: [String] = ["a", "b", "c", "d", "e"]
    var recentTags: [String] = ["k", "kk", "kkk", "kkkk", "kkkkk"]
    var oftenTags: [String] = ["좋은노래", "솝트", "전시회", "그래픽디자인", "포토서퍼", "인턴"]
    var platformTags: [String] = ["포토서퍼", "카페", "위시리스트", "휴학계획", "여행"]
    var relatedTags: [String] = ["avdsdaf", "sdfds", "fdsds", "ssss", "aaaaaafds"]
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    
    enum Section {
        case addedTag
        case recentTag
        case oftenTag
        case platformTag
        case relatedTag
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addedTagCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        setSearchBarUI()
        
        addedTagCollectionView.register(UINib(nibName: TagCollectionViewCell.identifier, bundle: nil),
                                        forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        addedTagCollectionView.register(UINib(nibName: TagsHeaderCollectionReusableView.identifier, bundle: nil),
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TagsHeaderCollectionReusableView.identifier)
        addedTagCollectionView.isScrollEnabled = true
        
        searchBar.delegate = self
        
        setHierarchy()
        setDataSource()
    }
    
    private func setSearchBarUI() {
        searchBar.layer.cornerRadius = 8
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.font = .iosBody2
        searchBar.placeholder = "태그를 입력하세요"
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        
    }
}
