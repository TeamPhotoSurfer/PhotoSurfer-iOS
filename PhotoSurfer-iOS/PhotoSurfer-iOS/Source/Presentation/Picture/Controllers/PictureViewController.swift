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
    
    enum PictureEditMode {
        case none
        case add
        case delete
        case edit
    }
    
    enum Section {
        case tag
    }
    
    // MARK: - Property
    let photo = Const.Image.imgSea
    var type: ViewType = .alarmSelected
    var editMode: PictureEditMode = .none
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var tags = [Tag(title: "tag1ㅋㅋㅋㅋㅋㅋㅋㅋㅋ"), Tag(title: "tag1"), Tag(title: "tag1"), Tag(title: "tag1")]
    
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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewType(type: type)
        setUI(editMode: editMode)
        setImageData()
        setCollectionView()
        setMoreButtonMenu()
        addKeyboardObserver()
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
    
    private func setViewType(type: ViewType) {
        [alarmDetailButton, shareButton].forEach {
            $0?.isHidden = (type == .picture)
        }
        [bottomWaveView, collectionView, navigationPictureButtonContainerStackView].forEach {
            $0?.isHidden = (type == .alarmSelected)
        }
    }
    
    private func setUI(editMode: PictureEditMode) {
        alarmDetailButton.layer.cornerRadius = 8
        keyboardTopTextField.layer.cornerRadius = 22
        keyboardTopTextField.layer.borderColor = UIColor.grayGray30.cgColor
        keyboardTopTextField.layer.borderWidth = 1
        keyboardTopTextField.addPadding(padding: 12)
        switch editMode {
        case .add:
            deleteButton.isHidden = true
            bottomShareButton.isHidden = true
            keyboardTopTextField.isHidden = false
        case .delete:
            print("delete")
        case .edit:
            deleteButton.isHidden = true
            bottomShareButton.isHidden = true
            keyboardTopTextField.isHidden = false
        case .none:
            deleteButton.isHidden = false
            bottomShareButton.isHidden = false
            keyboardTopTextField.isHidden = true
        }
    }
    
    private func setImageData() {
        imageView.image = photo
        scrollViewHeight.priority = UILayoutPriority(photo.size.height <= photo.size.width ? 1000 : 250)
    }
    
    private func setCollectionView() {
        registerXib()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource()
        applyTagsSnapshot()
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
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else { fatalError() }
            cell.setData(title: itemIdentifier.title, type: .defaultBlueTag)
            return cell
        })
    }
    
    private func applyTagsSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(tags, toSection: .tag)
        dataSource.apply(snapshot)
    }
    
    private func setMoreButtonMenu() {
        let addTag = UIAction(title: "태그추가") { action in
            self.editMode = .add
            self.setUI(editMode: self.editMode)
            self.keyboardTopTextField.becomeFirstResponder()
        }
        let deleteTag = UIAction(title: "태그삭제") { action in
            
        }
        let editTag = UIAction(title: "태그수정") { action in
            self.editMode = .edit
            self.setUI(editMode: self.editMode)
            self.keyboardTopTextField.becomeFirstResponder()
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
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        editMode = .none
        setUI(editMode: editMode)
        waveViewBottomConstraint.constant = 0
    }
    
    // MARK: - IBAction
    @IBAction func alarmDetailButtonDidTap(_ sender: Any) {
        guard let alarmDetailViewController = UIStoryboard(name: Const.Storyboard.AlarmDetail, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.AlarmDetailViewController) as? AlarmDetailViewController else { return }
        alarmDetailViewController.modalPresentationStyle = .fullScreen
        self.present(alarmDetailViewController, animated: true, completion: nil)
    }
}
