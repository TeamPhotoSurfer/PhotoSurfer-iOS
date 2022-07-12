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
    let sampleArray: [String] = ["포토서퍼", "카페", "위시리스트", "휴학계획", "여행"]
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    
    enum Section {
        case main
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addedTagCollectionView: UICollectionView!
    @IBOutlet weak var recentTagCollectionView: UICollectionView!
    @IBOutlet weak var oftenTagCollectionView: UICollectionView!
    @IBOutlet weak var platformTagCollectionView: UICollectionView!
    
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
        addedTagCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
