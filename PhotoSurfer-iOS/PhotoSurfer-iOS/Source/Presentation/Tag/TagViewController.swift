//
//  TagViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

struct Album: Hashable {
    let uuid = UUID()
    let isMarked: Bool
    let name: String
}

final class TagViewController: UIViewController {
    enum Section {
        case tag
    }

    // MARK: - Property
    var dataSource: UICollectionViewDiffableDataSource<Section, Album>!
    var albumList: [Album] = Album.list
    
    // MARK: - IBOutlet
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
    }
    
    // MARK: - Function
    private func setCollectionView() {
        registerXib()
        dataSource = UICollectionViewDiffableDataSource<Section, Album>(collectionView: albumCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell, for: indexPath) as? TagAlbumCollectionViewCell else { fatalError() }
            albumCell.setDummy(item)
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
        snapshot.appendSections([.tag])
        snapshot.appendItems(albumList, toSection: .tag)
        dataSource.apply(snapshot)
        albumCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top:  10, leading: 15, bottom: 15, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension Album {
    static let list = [
        Album(isMarked: true, name: "안녕하세요안녕하\n요안녕하세요안녕"),
        Album(isMarked: true, name: "instagram"),
        Album(isMarked: true, name: "youtube"),
        Album(isMarked: false, name: "cafe"),
        Album(isMarked: false, name: "dog"),
        Album(isMarked: false, name: "cat"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: true, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: true, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag"),
        Album(isMarked: false, name: "tag")
    ]
}
