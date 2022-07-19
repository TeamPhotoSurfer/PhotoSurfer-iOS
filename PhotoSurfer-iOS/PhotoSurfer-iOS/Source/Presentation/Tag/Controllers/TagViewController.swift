//
//  TagViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

struct Album: Hashable {
    let uuid = UUID()
    let isMarked: Bool
    let isPlatform: Bool
    var name: String
}

final class TagViewController: UIViewController {

    // MARK: - Property
    enum Section {
        case tag
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Album>!
    var albumList: [Album] = Album.totalList
    var indexpath: IndexPath = IndexPath.init()
    
    // MARK: - IBOutlet
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
        editTagTextField.layer.backgroundColor = UIColor.grayWhite.cgColor
        editTagTextField.layer.cornerRadius = editTagTextField.bounds.height * 0.5
        editTagTextField.addPadding(padding: 16)
        editTagTextField.clearButtonMode = .always
        editTagTextField.addTarget(self, action: #selector(self.editTagTextFieldDidChange(_:)), for: .editingChanged)
        setCollectionView()
        setEditToolbar()
    }
    
    private func setEditToolbar() {
        editTagTextField.inputAccessoryView = editToolBarView
        editTagTextField.returnKeyType = .done
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(albumList, toSection: .tag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setCollectionView() {
        registerXib()
        dataSource = UICollectionViewDiffableDataSource<Section, Album>(collectionView: albumCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagAlbumCollectionViewCell, for: indexPath) as? TagAlbumCollectionViewCell else { fatalError() }
            albumCell.setDummy(album: item)
            albumCell.tag = indexPath.row
            albumCell.tagDeleteButton.addTarget(self, action: #selector(self.deleteButtonDidTap), for: .touchUpInside)
            albumCell.platformTagDeleteButton.addTarget(self, action: #selector(self.deleteButtonDidTap), for: .touchUpInside)
            albumCell.tagEditButton.addTarget(self, action: #selector(self.editButtonDidTap), for: .touchUpInside)
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
    
    // MARK: - Objc Function
    @objc func deleteButtonDidTap(sender: UIButton) {
        var superview = sender.superview
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
    
    @objc func editButtonDidTap(sender: UIButton) {
        print("수정하기 클릭")
        var superview = sender.superview
        while superview != nil {
            if let cell = superview as? TagAlbumCollectionViewCell {
                guard let indexPath = albumCollectionView.indexPath(for: cell) else { return }
                indexpath = indexPath
                editTagTextField.becomeFirstResponder()
                editToolBarView.isHidden.toggle()
                cell.menuView.isHidden.toggle()
                break
            }
            superview = superview?.superview
        }
    }
    
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
        dataSource.apply(newSnapshot)
    }
    
    // MARK: - IBAction
    @IBAction func viewDidTap(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("CellTouch"), object: nil)
    }
}

extension Album {
    static var markList = [
        Album(isMarked: true, isPlatform: true, name: "유튜브"),
        Album(isMarked: true, isPlatform: true, name: "인스타그램"),
        Album(isMarked: true, isPlatform: true, name: "카카오톡"),
        Album(isMarked: true, isPlatform: false, name: "랄라"),
        Album(isMarked: true, isPlatform: true, name: "쇼핑몰"),
    ]
    static var list = [
        Album(isMarked: false, isPlatform: false, name: "cafe"),
        Album(isMarked: false, isPlatform: false, name: "air"),
        Album(isMarked: false, isPlatform: false, name: "tree"),
        Album(isMarked: false, isPlatform: false, name: "tag1"),
        Album(isMarked: false, isPlatform: false, name: "tag2"),
        Album(isMarked: false, isPlatform: false, name: "tag3"),
        Album(isMarked: false, isPlatform: false, name: "tag4"),
        Album(isMarked: false, isPlatform: false, name: "tag5"),
        Album(isMarked: false, isPlatform: false, name: "tag6"),
        Album(isMarked: false, isPlatform: false, name: "tag7"),
        Album(isMarked: false, isPlatform: false, name: "tag8"),
        Album(isMarked: false, isPlatform: false, name: "tag9"),
        Album(isMarked: false, isPlatform: false, name: "tag10"),
        Album(isMarked: false, isPlatform: false, name: "tag11"),
        Album(isMarked: false, isPlatform: false, name: "tag12"),
    ]
    static var totalList = markList + list
}
