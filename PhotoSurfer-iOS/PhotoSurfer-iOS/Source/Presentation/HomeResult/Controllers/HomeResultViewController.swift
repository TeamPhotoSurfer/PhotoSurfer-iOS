//
//  HomeResultViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

struct CapturePhoto: Hashable {
    // 이후 삭제
    let uuid = UUID()
    let image: UIImage
}

final class HomeResultViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - Property
    var tagDataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var photoDataSource: UICollectionViewDiffableDataSource<Section, CapturePhoto>!
    var tags: [Tag] = []
    var photos: [CapturePhoto] = []

    // MARK: - IBOutlet
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setDummy()
        setCollectionView()
    }
    
    private func setCollectionView() {
        registerXib()
        tagCollectionView.setCollectionViewLayout(createTagsLayout(), animated: true)
        photoCollectionView.setCollectionViewLayout(createPhotosLayout(), animated: true)
        setDataSource()
        applyTagSnapshot()
        applyPhotoSnapshot()
    }
    
    private func registerXib() {
        tagCollectionView.register(UINib(nibName: Const.Identifier.TagCollectionViewCell, bundle: nil),
                                   forCellWithReuseIdentifier: Const.Identifier.TagCollectionViewCell)
        photoCollectionView.register(UINib(nibName: Const.Identifier.PhotoCollectionViewCell, bundle: nil),
                                     forCellWithReuseIdentifier: Const.Identifier.PhotoCollectionViewCell)
    }
    
    private func setDataSource() {
        tagDataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: tagCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else { fatalError() }
            cell.setData(title: itemIdentifier.title, type: .deleteEnableBlueTag)
            return cell
        })
        photoDataSource = UICollectionViewDiffableDataSource<Section, CapturePhoto>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.PhotoCollectionViewCell, for: indexPath) as? PhotoCollectionViewCell else { fatalError() }
            cell.setData(image: itemIdentifier.image)
            return cell
        })
    }
    
    private func applyTagSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tags, toSection: .main)
        tagDataSource.apply(snapshot)
    }
    
    private func applyPhotoSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CapturePhoto>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        photoDataSource.apply(snapshot)
    }
    
    private func setDummy() {
        tags = [Tag(title: "태그"), Tag(title: "태그"), Tag(title: "태그"), Tag(title: "태그"), Tag(title: "태그"), Tag(title: "태그")]
        photos = [CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea),
                  CapturePhoto(image: Const.Image.imgSea)]
    }
}
