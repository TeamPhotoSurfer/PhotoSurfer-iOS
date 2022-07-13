//
//  TagViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

struct Album: Hashable {
    let isMarked: Bool
    let name: String
}

class TagViewController: UIViewController {
    enum Section {
        case main
    }

    // MARK: - Property
    var dataSource: UICollectionViewDiffableDataSource<Section, Album>!
    var albumList: [Album] = Album.list
    
    // MARK: - IBOutlet
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Function
    private func setCollectionView() {
        registerXib()
        dataSource = UICollectionViewDiffableDataSource<Section, Album>(collectionView: albumCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell, for: indexPath) as?  TagAlbumCollectionViewCell else { fatalError() }
            albumCell.setDumy(item)
            return albumCell
        })
        applyInitialDataSource()
    }
    
    private func registerXib() {
        albumCollectionView.register(UINib(nibName: Const.Identifier.TagAlbumCollectionViewCell, bundle: nil),
                                     forCellWithReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell)
    }
    
    private func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
        snapshot.appendSections([.main])
        snapshot.appendItems(albumList, toSection: .main)
        dataSource.apply(snapshot)
        albumCollectionView.collectionViewLayout = layout()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top:  15, leading: 20, bottom: 15, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension Album {
    static let list = [
        Album(isMarked: true, name: "tag"),
        Album(isMarked: true, name: "instagram"),
        Album(isMarked: true, name: "youtube"),
        Album(isMarked: false, name: "cafe"),
        Album(isMarked: false, name: "dog"),
        Album(isMarked: false, name: "cat"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag")
    ]
}
