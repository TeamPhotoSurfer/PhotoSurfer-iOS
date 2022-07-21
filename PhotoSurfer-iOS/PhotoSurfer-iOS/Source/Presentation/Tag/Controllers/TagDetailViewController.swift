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

final class TagDetailViewController: UIViewController {
    
    enum Section {
        case photo
    }
    
    // MARK: - Property
    var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var photos: [Photo] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectedNavigationStackView: UIStackView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var bottomWaveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollectionView()
    }
    
    private func setUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(setPhotos), name: Notification.Name("TagDetailPresent"), object: nil)
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
        photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.PhotoCollectionViewCell, for: indexPath) as? PhotoCollectionViewCell else { fatalError() }
            cell.imageView.setImage(with: item.imageURL)
            return cell
        })
    }
    
    func applyPhotoSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
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
    
    // MARK: - Objc Function
    @objc func setPhotos(notification: NSNotification) {
        print("setPhotos")
        guard let tag = notification.object as? Tag else { return }
        tagNameLabel.text = tag.name
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectButtonDidTap(_ sender: Any) {
        toggleMultiSelectedUI(isSelectable: true)
    }
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        toggleMultiSelectedUI(isSelectable: false)
    }
}

extension TagDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell 선택")
        guard let pictureViewController = UIStoryboard(name: Const.Storyboard.Picture, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.PictureViewController) as? PictureViewController else { return }
        pictureViewController.type = .picture
        self.navigationController?.pushViewController(pictureViewController, animated: true)
    }
}

