//
//  HomeResultViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

import IQKeyboardManagerSwift

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
    var isHiddenCollectionView: Bool = false
    var tagDataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var tags: [Tag] = []
    var photos: [Photo] = []
    var selectedPhotos: [Photo] = []
    var isMultiSelectMode: Bool = false
    var editMode: HomeResultEditMode = .none
    var editSelectTag: Tag?
    var editIdx: Int?
    
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
    @IBOutlet weak var waveViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagOnboardingButton: UIButton!
    @IBOutlet weak var keyboardTopTextField: UITextField!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tagCollectionViewHeightConst: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tags.map({ $0.id }))
        tagCollectionView.isHidden = isHiddenCollectionView
        if isHiddenCollectionView {
            tagCollectionViewHeightConst.constant = 0
        }
        setUI(mode: editMode)
        setCollectionView()
        addKeyboardObserver()
        setTextFieldDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardManagerEnable(false)
        if editMode == .none {
            getPhotoSearch()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setKeyboardManagerEnable(true)
        removeKeyboardObserver()
    }
    
    private func setKeyboardManagerEnable(_ isEnabled: Bool) {
        IQKeyboardManager.shared.enable = isEnabled
    }
    
    func hideTagCollectionView() {
        tagCollectionView.isHidden = true
    }
    
    private func setUI(mode: HomeResultEditMode) {
        navigationTitleLabel.text = mode.rawValue
        setTextFieldUI()
        setButtonUI()
        switch mode {
        case .none:
            print("none")
            keyboardTopTextField.isHidden = true
        case .add:
            print("add")
            keyboardTopTextField.becomeFirstResponder()
            keyboardTopTextField.placeholder = "추가할 태그를 입력하세요"
            setEditModeUI()
        case .delete:
            print("delete")
            keyboardTopTextField.isHidden = true
            setEditModeUI()
        case .edit:
            print("edit")
            keyboardTopTextField.isHidden = true
            keyboardTopTextField.placeholder = "수정할 태그를 입력하세요"
            setEditModeUI()
        }
    }
    
    private func setTextFieldUI() {
        keyboardTopTextField.layer.cornerRadius = 22
        keyboardTopTextField.layer.borderColor = UIColor.grayGray30.cgColor
        keyboardTopTextField.layer.borderWidth = 1
        keyboardTopTextField.addPadding(padding: 12)
    }
    
    private func setButtonUI() {
        tagOnboardingButton.layer.cornerRadius = 8
        
    }
    
    private func setEditModeUI() {
        selectButton.isHidden = true
        bottomWaveImageContainerView.isHidden = false
        deleteButton.isHidden = true
        shareButton.isHidden = true
    }
    
    private func setTextFieldDelegate() {
        keyboardTopTextField.delegate = self
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
            } else if self.editMode == .edit {
                if let tag = self.editSelectTag {
                    cell.setData(title: itemIdentifier.name, type: (itemIdentifier.id == tag.id) ? .defaultSkyblueTag : .defaultBlueTag)
                }
                else {
                    cell.setData(title: itemIdentifier.name, type: .defaultBlueTag)
                }
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
            self.emptyView.isHidden = false
            applyPhotoSnapshot()
        } else {
            PhotoService.shared.getPhotoSearch(ids: tagIds) { response in
                switch response {
                case .success(let data):
                    self.emptyView.isHidden = true
                    guard let data = data as? PhotoSearchResponse else { return }
                    self.photos = data.photos
                    self.applyPhotoSnapshot()
                case .requestErr(_):
                    self.emptyView.isHidden = false
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
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    // MARK: - Objc Function
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            waveViewBottomConstraint.constant = keyboardHeight
            keyboardTopTextField.isHidden = false
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        waveViewBottomConstraint.constant = 0
        keyboardTopTextField.isHidden = true
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
    @IBAction func tagOnboardingButtonDidTap(_ sender: Any) {
        let onboardingViewController = UIStoryboard(name: Const.Storyboard.Onboarding, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.OnboardingViewController)
        self.present(onboardingViewController, animated: true)
    }
}
