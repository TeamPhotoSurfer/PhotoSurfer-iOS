//
//  PictureViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

final class PictureViewController: UIViewController {
    
    enum ViewType {
        case picture
        case alarmSelected
    }
    
    enum Section {
        case tag
    }
    
    // MARK: - Property
    let photo = Const.Image.imgSea
    var type: ViewType = .alarmSelected
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var tags = [Tag(title: "tag1"), Tag(title: "tag1"), Tag(title: "tag1"), Tag(title: "tag1")]
    
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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewType(type: type)
        setUI()
        setImageData()
        setCollectionView()
    }
    
    // MARK: - Function
    private func setViewType(type: ViewType) {
        [alarmDetailButton, shareButton].forEach {
            $0?.isHidden = (type == .picture)
        }
        [bottomWaveView, collectionView, navigationPictureButtonContainerStackView].forEach {
            $0?.isHidden = (type == .alarmSelected)
        }
    }
    
    private func setUI() {
        alarmDetailButton.layer.cornerRadius = 8
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
            cell.setData(title: itemIdentifier.title, isInputTag: true)
            return cell
        })
    }
    
    private func applyTagsSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.tag])
        snapshot.appendItems(tags, toSection: .tag)
        dataSource.apply(snapshot)
    }
    
    // MARK: - IBAction
    @IBAction func alarmDetailButtonDidTap(_ sender: Any) {
        guard let alarmDetailViewController = UIStoryboard(name: Const.Storyboard.AlarmDetail, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.AlarmDetailViewController) as? AlarmDetailViewController else { return }
        alarmDetailViewController.modalPresentationStyle = .fullScreen
        self.present(alarmDetailViewController, animated: true, completion: nil)
    }
}
