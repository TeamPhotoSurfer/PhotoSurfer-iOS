//
//  TagViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class TagViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Property
    enum Section {
        case tag
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var bookmarkedList: [Tag] = []
    var notBookmarkedList: [Tag] = []
    var indexpath: IndexPath = IndexPath.init()
    
    // MARK: - IBOutlet
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var editTagTextField: UITextField!
    @IBOutlet weak var editToolBarView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getTag()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObserver()
    }
    
    // MARK: - Function
    private func removeObserver() {
        NotificationCenter.default.removeObserver(Notification.Name("TagDetailPresent"))
    }
    
    private func setUI() {
        setEditTagTextField()
        setCollectionView()
        setEditToolbar()
        editTagTextField.delegate = self
        albumCollectionView.delegate = self
        setEmptyView()
    }
    
    private func setEditTagTextField() {
        editTagTextField.layer.backgroundColor = UIColor.grayWhite.cgColor
        editTagTextField.layer.cornerRadius = editTagTextField.bounds.height * 0.5
        editTagTextField.addPadding(padding: 16)
        editTagTextField.clearButtonMode = .always
        editTagTextField.addTarget(self, action: #selector(self.editTagTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setEmptyView() {
        if (bookmarkedList + notBookmarkedList).count == 0 {
            self.emptyView.isHidden = false
        }
    }
    
    private func setEditToolbar() {
        editTagTextField.inputAccessoryView = editToolBarView
        editTagTextField.returnKeyType = .done
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(bookmarkedList, toSection: .tag)
        snapshot.appendItems(notBookmarkedList, toSection: .tag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setCollectionView() {
        registerXib()
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: albumCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell, for: indexPath) as? TagAlbumCollectionViewCell else { fatalError() }
            albumCell.setData(tag: item)
            albumCell.tag = indexPath.row
            albumCell.delegate = self
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
    
    private func getTag() {
        TagService.shared.getTag { [weak self] response in
            switch response {
            case .success(let data):
                print("✨before data", data)
                guard let data = data as? TagBookmarkResponse else { return }
                print("✨data", data)
                self?.bookmarkedList = data.bookmarked.tags ?? []
//                print(self?.bookmarkedList)
                self?.notBookmarkedList = data.notBookmarked.tags ?? []
                self?.applySnapshot()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("🚨resign", editTagTextField.resignFirstResponder())
        return true
    }
    
    // MARK: - Objc Function
    @objc func editTagTextFieldDidChange(_ sender: Any?) {
        guard let tagName = self.editTagTextField?.text else { return }
        guard let selectedItem = dataSource.itemIdentifier(for: indexpath) else { return }
        var updatedSelectedItem = selectedItem
        updatedSelectedItem.name = tagName
        var newSnapshot = dataSource.snapshot()
//        newSnapshot.reloadItems([selectedItem])
//        newSnapshot.reconfigureItems([selectedItem])
        newSnapshot.insertItems([updatedSelectedItem], beforeItem: selectedItem)
        newSnapshot.deleteItems([selectedItem])
        dataSource.apply(newSnapshot, animatingDifferences: false, completion: nil)
    }
}

extension TagViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        guard let cell = collectionView.cellForItem(at: indexPath) as? TagAlbumCollectionViewCell else { return }
        let tagDetailViewController = UIStoryboard(name: Const.Storyboard.TagDetail, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.TagDetailViewController)
        tagDetailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tagDetailViewController, animated: true)
        NotificationCenter.default.post(name: Notification.Name("TagDetailPresent"), object: item.name)
    }
}

extension TagViewController: MenuHandleDelegate {
    func deleteButtonDidTap(button: UIButton) {
        print("삭제하기 클릭")
        var superview = button.superview
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
    }
    
    func editButtonDidTap(button: UIButton) {
        print("수정하기 클릭")
        var superview = button.superview
        while superview != nil {
            if let cell = superview as? TagAlbumCollectionViewCell {
                guard let indexPath = albumCollectionView.indexPath(for: cell) else { return }
                print("셀을 찾았다")
                indexpath = indexPath
                editToolBarView.isHidden = false
                print("✨can?", editTagTextField.canBecomeFirstResponder)
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        print("🧤become", self.editTagTextField.becomeFirstResponder())
                    }
                }
                editTagTextField.text = cell.tagNameButton.titleLabel?.text
                break
            }
            superview = superview?.superview
        }
    }
    
    // MARK: - IBAction
    @IBAction func onboardingButtonDidTap(_ sender: Any) {
        let onboardingViewController = UIStoryboard(name: Const.Storyboard.Onboarding, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.OnboardingViewController)
        self.present(onboardingViewController, animated: true)
    }
}
