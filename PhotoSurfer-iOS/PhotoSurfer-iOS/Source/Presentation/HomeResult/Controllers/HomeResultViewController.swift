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
    
    enum HomeResultEditMode: String {
        case none = "검색 결과"
        case add = "공용 태그 추가"
        case delete = "입력된 태그 삭제"
        case edit = "입력된 태그 수정"
    }
    
    // MARK: - Property
    var tagDataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var tags: [Tag] = []
    var photos: [Photo] = []
    var selectedPhotos: [Photo] = []
    var isMultiSelectMode: Bool = false
    var editMode: HomeResultEditMode = .none
    
    // MARK: - IBOutlet
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var bottomWaveView: UIView!
    @IBOutlet weak var selectedNavigationStackView: UIStackView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var waveImageView: UIImageView!
    @IBOutlet weak var bottomWaveImageContainerView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tags.map({ $0.id }))
        setUI(mode: editMode)
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if editMode == .none {
            getPhotoSearch()
        }
    }
    
    private func setUI(mode: HomeResultEditMode) {
        navigationTitleLabel.text = mode.rawValue
        switch mode {
        case .none:
            print("none")
        case .add:
            print("add")
            setEditModeUI()
        case .delete:
            print("delete")
            setEditModeUI()
        case .edit:
            print("edit")
            setEditModeUI()
        }
    }
    
    private func setEditModeUI() {
        selectButton.isHidden = true
        bottomWaveImageContainerView.isHidden = false
        deleteButton.isHidden = true
        shareButton.isHidden = true
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
    
    func setDataSource() {
        tagDataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: tagCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else { fatalError() }
            if (self.editMode == .none) || (self.editMode == .delete) {
                cell.setData(title: itemIdentifier.name, type: .deleteEnableBlueTag)
            } else {
                cell.setData(title: itemIdentifier.name, type: .defaultBlueTag)
            }
            
            return cell
        })
        photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.PhotoCollectionViewCell, for: indexPath) as? PhotoCollectionViewCell else { fatalError() }
            cell.setServerData(imageURL: itemIdentifier.imageURL,
                               selected: self.selectedPhotos.contains(where: {
                $0.id == itemIdentifier.id
            }))
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
    
    private func goToEditResultViewController(editMode: HomeResultEditMode) {
        guard let editResultViewController = self.storyboard?.instantiateViewController(withIdentifier: Const.ViewController.HomeResultViewController) as? HomeResultViewController else { return }
        editResultViewController.editMode = editMode
        editResultViewController.photos = selectedPhotos
        editResultViewController.tags = tags
        self.navigationController?.pushViewController(editResultViewController, animated: true)
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
    
    func deletePhotos() {
        PhotoService.shared.putPhoto(ids: selectedPhotos.map({ $0.id })) { response in
            switch response {
            case .success(let data):
                print(data)
                self.getPhotoSearch()
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
    
    private func setMoreButtonMenu() {
        let addTag = UIAction(title: "태그추가") { action in
            self.goToEditResultViewController(editMode: .add)
        }
        let deleteTag = UIAction(title: "태그삭제") { action in
            self.goToEditResultViewController(editMode: .delete)
        }
        let editTag = UIAction(title: "태그수정") { action in
            self.goToEditResultViewController(editMode: .edit)
        }
        moreButton.menu = UIMenu(title: "", children: [addTag, deleteTag, editTag])
        moreButton.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectButtonDidTap(_ sender: Any) {
        isMultiSelectMode.toggle()
        toggleMultiSelectedUI(isSelectable: true)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        isMultiSelectMode.toggle()
        selectedPhotos = []
        setDataSource()
        applyTagSnapshot()
        applyPhotoSnapshot()
        toggleMultiSelectedUI(isSelectable: false)
    }
    
    @IBAction func photosDeleteButtonDidTap(_ sender: Any) {
        deletePhotos()
    }
    
    @IBAction func moreButtonDidTap(_ sender: Any) {
        setMoreButtonMenu()
    }
}
