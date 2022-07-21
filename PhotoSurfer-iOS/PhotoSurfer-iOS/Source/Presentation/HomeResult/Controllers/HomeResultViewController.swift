//
//  HomeResultViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

final class HomeResultViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - Property
    var tagDataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var tags: [Tag] = []
    var photos: [Photo] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var bottomWaveView: UIView!
    @IBOutlet weak var selectedNavigationStackView: UIStackView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tags.map({ $0.id }))
        
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPhotoSearch()
    }
    
    private func setCollectionView() {
        setCollectionViewDelegate()
        registerXib()
        tagCollectionView.setCollectionViewLayout(createTagsLayout(), animated: true)
        photoCollectionView.setCollectionViewLayout(createPhotosLayout(), animated: true)
        setDataSource()
        applyTagSnapshot()
        applyPhotoSnapshot()
    }
    
    private func setCollectionViewDelegate() {
        tagCollectionView.delegate = self
        photoCollectionView.delegate = self
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
            cell.setData(title: itemIdentifier.name, type: .deleteEnableBlueTag)
            return cell
        })
        photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.PhotoCollectionViewCell, for: indexPath) as? PhotoCollectionViewCell else { fatalError() }
            cell.setServerData(imageURL: itemIdentifier.imageURL)
            return cell
        })
    }
    
    func applyTagSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tags, toSection: .main)
        tagDataSource.apply(snapshot)
    }
    
    func applyPhotoSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        photoDataSource.apply(snapshot)
    }
    
    func goToPictureViewController(photoId: Int) {
        guard let pictureViewController = UIStoryboard(name: Const.Storyboard.Picture, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.PictureViewController) as? PictureViewController else { return }
        pictureViewController.photoID = photoId
        pictureViewController.type = .picture
        self.navigationController?.pushViewController(pictureViewController, animated: true)
    }
    
    private func toggleMultiSelectedUI(isSelectable: Bool) {
        bottomWaveView.isHidden = !isSelectable
        selectedNavigationStackView.isHidden = !isSelectable
        selectButton.isHidden = isSelectable
    }
    
    func getPhotoSearch() {
        print("tags", tags)
        let tagIds: [Int] = tags.map({ $0.id ?? 0 })
        if tagIds.count == 0 {
            photos = []
            applyPhotoSnapshot()
        } else {
            PhotoService.shared.getPhotoSearch(ids: tagIds) { response in
                switch response {
                case .success(let data):
                    guard let data = data as? PhotoSearchResponse else { return }
                    self.photos = data.photos
                    self.applyPhotoSnapshot()
                case .requestErr(_):
                    print("requestErr")
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }
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
