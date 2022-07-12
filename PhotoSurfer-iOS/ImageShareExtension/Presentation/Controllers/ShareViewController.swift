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
        addedTagCollectionView.register(UINib(nibName: TagCollectionViewCell.identifier, bundle: nil),
                                        forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        addedTagCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        setHierarchy()
        setDataSource()
    }
}
