//
//  PictureViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

import IQKeyboardManagerSwift

final class PictureViewController: UIViewController {
    
    enum ViewType {
        case picture
        case alarmSelected
    }
    
    enum PictureEditMode: String {
        case none = ""
        case add = "태그 추가"
        case delete = "태그 삭제"
        case edit = "태그 수정"
    }
    
    enum Section {
        case tag
    }
    
    // MARK: - Property
    var photoID: Int?
    var photo = Const.Image.imgSea
    var type: ViewType = .alarmSelected
    var editMode: PictureEditMode = .none
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var tags: [Tag] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var navigationPictureButtonContainerStackView: UIStackView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var alarmDetailButton: UIButton!
    @IBOutlet weak var bottomWaveView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var waveViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardTopTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var bottomShareButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var navigationAlarmButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotoDetail()
        setViewType(type: type)
        setUI(editMode: editMode)
        setImageData()
        setCollectionView()
        setMoreButtonMenu()
        addKeyboardObserver()
        setTextFieldDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardManagerEnable(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
        setKeyboardManagerEnable(true)
    }
    
    // MARK: - Function
    private func setKeyboardManagerEnable(_ isEnabled: Bool) {
        IQKeyboardManager.shared.enable = isEnabled
    }
    
    private func setTextFieldDelegate() {
        keyboardTopTextField.delegate = self
    }
    
    private func setViewType(type: ViewType) {
        [alarmDetailButton, shareButton].forEach {
            $0?.isHidden = (type == .picture)
        }
        [bottomWaveView, collectionView, navigationAlarmButton, moreButton].forEach {
            $0?.isHidden = (type == .alarmSelected)
        }
    }
    
    private func setUI(editMode: PictureEditMode) {
        alarmDetailButton.layer.cornerRadius = 8
        setKeyboardTopTextFieldUI()
        isEditModeUI(editMode != .none,
                     isShownTextField: editMode == .add)
        navigationTitleLabel.text = editMode.rawValue
        if editMode == .add {
            keyboardTopTextField.becomeFirstResponder()
        }
        else if editMode == .edit {
            keyboardTopTextField.placeholder = "수정할 태그를 입력하세요"
        }
    }
    
    private func isEditModeUI(_ isEdit: Bool, isShownTextField: Bool) {
        deleteButton.isHidden = isEdit
        bottomShareButton.isHidden = isEdit
        navigationPictureButtonContainerStackView.isHidden = isEdit
    }
    
    private func setKeyboardTopTextFieldUI() {
        keyboardTopTextField.layer.cornerRadius = 22
        keyboardTopTextField.layer.borderColor = UIColor.grayGray30.cgColor
        keyboardTopTextField.layer.borderWidth = 1
        keyboardTopTextField.addPadding(padding: 12)
    }
    
    private func setImageData() {
        imageView.image = photo
        scrollViewHeight.priority = UILayoutPriority(photo.size.height <= photo.size.width ? 1000 : 250)
    }
    
    private func setCollectionView() {
        registerXib()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource(isDeletable: editMode == .delete, editIdx: nil)
        applyTagsSnapshot()
        collectionView.delegate = self
    }
    
    private func registerXib() {
        collectionView.register(UINib(nibName: Const.Identifier.PhotoCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: Const.Identifier.PhotoCollectionViewCell)
        collectionView.register(UINib(nibName: Const.Identifier.TagCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: Const.Identifier.TagCollectionViewCell)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 6
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setDataSource(isDeletable: Bool, editIdx: Int?) {
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else { fatalError() }
            if let editIdx = editIdx {
                cell.setData(title: itemIdentifier.name,
                             type: self.tags[indexPath.item].uuid == self.tags[editIdx].uuid ? .defaultSkyblueTag : .defaultBlueTag)
            } else {
                cell.setData(title: itemIdentifier.name,
                             type: isDeletable ? .deleteEnableBlueTag : .defaultBlueTag)
            }
            return cell
        })
    }
    
    func applyTagsSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(tags, toSection: .tag)
        dataSource.apply(snapshot)
    }
    
    private func goToEditPictureViewController(editMode: PictureEditMode) {
        guard let editPictureViewController = self.storyboard?
                .instantiateViewController(withIdentifier: Const.ViewController.PictureViewController) as? PictureViewController else { return }
        editPictureViewController.type = .picture
        editPictureViewController.editMode = editMode
        self.navigationController?.pushViewController(editPictureViewController, animated: true)
    }
    
    private func setMoreButtonMenu() {
        let addTag = UIAction(title: "태그추가") { action in
            self.goToEditPictureViewController(editMode: .add)
        }
        let deleteTag = UIAction(title: "태그삭제") { action in
            self.goToEditPictureViewController(editMode: .delete)
        }
        let editTag = UIAction(title: "태그수정") { action in
            self.goToEditPictureViewController(editMode: .edit)
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
    
    private func getPhotoDetail() {
        guard let photoID = photoID else {
            return
        }
        PhotoService.shared.getPhotoDetail(id: photoID) { response in
            switch response {
            case .success(let data):
                guard let data = data as? Photo else { return }
                self.imageView.setImage(with: data.imageURL)
                self.tags = data.tags ?? []
                self.applyTagsSnapshot()
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
        if editMode == .edit {
            setDataSource(isDeletable: false, editIdx: nil)
            applyTagsSnapshot()
        }
    }
    
    // MARK: - IBAction
    @IBAction func alarmDetailButtonDidTap(_ sender: Any) {
        guard let alarmDetailViewController = UIStoryboard(name: Const.Storyboard.AlarmDetail, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.AlarmDetailViewController) as? AlarmDetailViewController else { return }
        alarmDetailViewController.modalPresentationStyle = .fullScreen
        self.present(alarmDetailViewController, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonDidTap(_ sender: Any) {
        keyboardTopTextField.resignFirstResponder()
    }
}
