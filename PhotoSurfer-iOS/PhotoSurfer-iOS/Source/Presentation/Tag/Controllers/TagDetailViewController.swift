//
//  TagDetailViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/20.
//

import UIKit

struct TagPhoto: Hashable {
    let uuid = UUID()
    let image: UIImage
}

final class TagDetailViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section {
        case photo
    }
    
    // MARK: - Property
    var photoDataSource: UICollectionViewDiffableDataSource<Section, TagPhoto>!
    var photos: [TagPhoto] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectedNavigationStackView: UIStackView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var bottomWaveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDummy()
        setCollectionView()
    }
    
    private func setCollectionView() {
        setCollectionViewDelegate()
        registerXib()
        photoCollectionView.setCollectionViewLayout(createPhotosLayout(), animated: true)
        setDataSource()
        applyPhotoSnapshot()
    }
    
    private func registerXib() {
        photoCollectionView.register(UINib(nibName: Const.Identifier.PhotoCollectionViewCell, bundle: nil),
                                     forCellWithReuseIdentifier: Const.Identifier.PhotoCollectionViewCell)
    }
    
    private func setDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource<Section, TagPhoto>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.PhotoCollectionViewCell, for: indexPath) as? PhotoCollectionViewCell else { fatalError() }
            cell.setData(image: itemIdentifier.image)
            return cell
        })
    }
    
    func applyPhotoSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TagPhoto>()
        snapshot.appendSections([.photo])
        snapshot.appendItems(photos, toSection: .photo)
        photoDataSource.apply(snapshot)
    }
    
    func goToPictureViewController() {
        guard let pictureViewController = UIStoryboard(name: Const.Storyboard.Picture, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.PictureViewController) as? PictureViewController else { return }
        pictureViewController.type = .picture
        self.navigationController?.pushViewController(pictureViewController, animated: true)
    }
    
    private func toggleMultiSelectedUI(isSelectable: Bool) {
        bottomWaveView.isHidden = !isSelectable
        selectedNavigationStackView.isHidden = !isSelectable
        selectButton.isHidden = isSelectable
    }
    
    private func setDummy() {
        photos = [
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
            TagPhoto(image: Const.Image.imgSea),
        ]
    }
    
    func createPhotosLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setCollectionViewDelegate() {
        photoCollectionView.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func selectButtonDidTap(_ sender: Any) {
        toggleMultiSelectedUI(isSelectable: true)
    }
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        toggleMultiSelectedUI(isSelectable: false)
    }
}
