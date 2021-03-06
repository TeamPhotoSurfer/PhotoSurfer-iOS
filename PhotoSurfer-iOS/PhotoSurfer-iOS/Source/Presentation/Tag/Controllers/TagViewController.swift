//
//  TagViewController.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνλ on 2022/07/10.
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
    var totalList: [Tag]?
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
    }
    
    // MARK: - Function
    private func setUI() {
        getTag()
        setEditTagTextField()
        setCollectionView()
        setEditToolbar()
        editTagTextField.delegate = self
        albumCollectionView.delegate = self
        
    }
    
    private func setEditTagTextField() {
        editTagTextField.layer.backgroundColor = UIColor.grayWhite.cgColor
        editTagTextField.layer.cornerRadius = editTagTextField.bounds.height * 0.5
        editTagTextField.addPadding(padding: 16)
        editTagTextField.clearButtonMode = .always
        editTagTextField.addTarget(self, action: #selector(self.editTagTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setEmptyView() {
        self.emptyView.isHidden = (bookmarkedList + notBookmarkedList).count != 0
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
        setEmptyView()
    }
    
    private func applySnapshotTotal(totalList: [Tag]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(totalList, toSection: .tag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setCollectionView() {
        registerXib()
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: albumCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell, for: indexPath) as? TagAlbumCollectionViewCell else { fatalError() }
            albumCell.setData(tag: item)
            albumCell.tag = indexPath.row
            albumCell.delegate = self
            albumCell.starDelegate = self
            return albumCell
        })
        albumCollectionView.collectionViewLayout = createLayout()
    }
    
    private func registerXib() {
        albumCollectionView.register(UINib(nibName: Const.Identifier.TagAlbumCollectionViewCell, bundle: nil),
                                     forCellWithReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell)
    }
    
    private func setTotalList() {
        totalList = bookmarkedList + notBookmarkedList
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
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
                guard let data = data as? TagBookmarkResponse else { return }
                self?.bookmarkedList = data.bookmarked.tags
                self?.notBookmarkedList = data.notBookmarked.tags
                self?.applySnapshot()
                self?.setTotalList()
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
    
    private func putTagBookmark(id: Int) {
        TagService.shared.putTagBookmark(id: id) { response in
            switch response {
            case .success(let data):
                print("β¨data",data)
                self.getTag()
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
    
    private func delTagBookmark(id: Int) {
        TagService.shared.delTagBookmark(id: id) { response in
            switch response {
            case .success(let data):
                print(data)
                self.getTag()
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
    
    private func delTag(id: Int) {
        TagService.shared.delTag(id: id) { response in
            switch response {
            case .success(let data):
                print(data)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("β¨resign", editTagTextField.resignFirstResponder())
        return true
    }
    
    // MARK: - Objc Function
    // TODO: νκ·Έ μ¨λ² edit κΈ°λ₯ μμ 
    @objc func editTagTextFieldDidChange(_ sender: Any?) {
        guard let tagName = self.editTagTextField?.text else { return }
        var totalList = bookmarkedList + notBookmarkedList
        totalList[indexpath.item].name = tagName
        applySnapshotTotal(totalList: totalList)
//        guard let selectedItem = dataSource.itemIdentifier(for: indexpath) else { return }
//        var updatedSelectedItem = selectedItem
//        updatedSelectedItem.name = tagName
//        var newSnapshot = dataSource.snapshot()
////        newSnapshot.reloadItems([selectedItem])
////        newSnapshot.reconfigureItems([selectedItem])
//        newSnapshot.insertItems([updatedSelectedItem], beforeItem: selectedItem)
//        newSnapshot.deleteItems([selectedItem])
//        dataSource.apply(newSnapshot, animatingDifferences: false, completion: nil)
    }
}

extension TagViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let tagDetailViewController = UIStoryboard(name: Const.Storyboard.TagDetail, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.TagDetailViewController) as? TagDetailViewController else { return }
        tagDetailViewController.modalPresentationStyle = .fullScreen
        tagDetailViewController.tag = item
        self.navigationController?.pushViewController(tagDetailViewController, animated: true)
         */
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let resultViewController = UIStoryboard(name: Const.Storyboard.HomeResult, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.HomeResultViewController) as? HomeResultViewController else { return }
        resultViewController.tags = [item]
        resultViewController.isHiddenCollectionView = true
        resultViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
}

extension TagViewController: StarHandleDelegate {
    func starButtonTapped(cell: TagAlbumCollectionViewCell) {
        print("β¨isSelected", cell.tagStarButton.isSelected)
        print("β¨starButtonDidTap")
        guard let indexPath = albumCollectionView.indexPath(for: cell) else { return }
        guard let tag = totalList?[indexPath.item] else { return }
        if cell.tagStarButton.isSelected {
            putTagBookmark(id: tag.id ?? 0)
        } else {
            delTagBookmark(id: tag.id ?? 0)
        }
        
        
    }
}

extension TagViewController: MenuHandleDelegate {
    func deleteButtonDidTap(button: UIButton) {
        print("β¨μ­μ νκΈ° ν΄λ¦­")
        var superview = button.superview
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = albumCollectionView.indexPath(for: cell),
                      let objectIClickedOnto = dataSource.itemIdentifier(for: indexPath) else { return }
                guard let tag = totalList?[indexPath.item] else { return }
                delTag(id: tag.id ?? 0)
                var snapshot = dataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                dataSource.apply(snapshot)
                break
            }
            superview = superview?.superview
        }
    }
    
    func editButtonDidTap(button: UIButton) {
        print("β¨editButtonDidTap")
        let superview = button.superview
        guard let cell = superview as? TagAlbumCollectionViewCell else { return }
        guard let indexPath = albumCollectionView.indexPath(for: cell) else { return }
        print("β¨μμ μ°Ύμλ€")
        indexpath = indexPath
        editToolBarView.isHidden = false
        print("β¨can?", editTagTextField.canBecomeFirstResponder)
        print("β¨become", self.editTagTextField.becomeFirstResponder())
        editTagTextField.text = cell.tagNameButton.titleLabel?.text
//        while superview != nil {
//            if let cell = superview as? TagAlbumCollectionViewCell {
//                guard let indexPath = albumCollectionView.indexPath(for: cell) else { return }
//                print("β¨μμ μ°Ύμλ€")
//                indexpath = indexPath
//                editToolBarView.isHidden = false
//                print("β¨can?", editTagTextField.canBecomeFirstResponder)
//                print("β¨become", self.editTagTextField.becomeFirstResponder())
//                editTagTextField.text = cell.tagNameButton.titleLabel?.text
//                break
//            }
//            superview = superview?.superview
//        }
    }
    
    // MARK: - IBAction
    @IBAction func onboardingButtonDidTap(_ sender: Any) {
        let onboardingViewController = UIStoryboard(name: Const.Storyboard.Onboarding, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.OnboardingViewController)
        self.present(onboardingViewController, animated: true)
    }
}
