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
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(albumList, toSection: .tag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setCollectionView() {
        registerXib()
        dataSource = UICollectionViewDiffableDataSource<Section, Album>(collectionView: albumCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell, for: indexPath) as? TagAlbumCollectionViewCell else { fatalError() }
            albumCell.cellDelegate = self
            albumCell.setDummy(item)
            albumCell.tag = indexPath.row
            albumCell.tagDeleteButton.tag = indexPath.row
            albumCell.tagEditButton.tag = indexPath.row
            albumCell.tagStarButton.tag = indexPath.row
            albumCell.tagDeleteButton.addTarget(self, action: #selector(self.deleteButtonDidTap), for: .touchUpInside)
            return albumCell
        })
        applySnapshot()
        albumCollectionView.collectionViewLayout = createLayout()
    }
    
    private func registerXib() {
        albumCollectionView.register(UINib(nibName: Const.Identifier.TagAlbumCollectionViewCell, bundle: nil),
                                     forCellWithReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top:  10, leading: 15, bottom: 10, trailing: 15)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - Objc Function
    @objc func deleteButtonDidTap(sender: UIButton) {
        var superview = sender.superview
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = albumCollectionView.indexPath(for: cell),
                      let objectIClickedOnto = dataSource.itemIdentifier(for: indexPath) else { return }
                var snapshot = dataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                dataSource.apply(snapshot)
                break
            }
            superview = superview?.superview
        }
        print("태그 삭제, ", sender.tag)
//        Album.list.remove(at: sender.tag)
//        applySnapshot()
    }
}

extension TagViewController: TagAlbumCellDelegate {
    func deleteButtonDidTap() {
        print("태그 삭제")
    }
}

extension Album {
    static var list = [
        Album(isMarked: true, name: "일이삼사오육칠녕하요안녕하세"),
        Album(isMarked: true, name: "instagram"),
        Album(isMarked: true, name: "youtube"),
        Album(isMarked: false, name: "cafe"),
        Album(isMarked: false, name: "dog"),
        Album(isMarked: false, name: "cat"),
        Album(isMarked: false, name: "tag6"),
        Album(isMarked: false, name: "tag7"),
        Album(isMarked: false, name: "tag8"),
        Album(isMarked: false, name: "tag9"),
        Album(isMarked: false, name: "tag10"),
        Album(isMarked: false, name: "tag11"),
        Album(isMarked: false, name: "tag12"),
        Album(isMarked: false, name: "tag13"),
        Album(isMarked: false, name: "tag14"),
        Album(isMarked: false, name: "tag15")
    ]
    static let totalList = markList + list
}
