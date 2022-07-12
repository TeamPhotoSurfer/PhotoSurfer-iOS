//
//  ShareViewController+Extension.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/12.
//

import UIKit

extension ShareViewController {
    
    // MARK: - Property
    static let titleElementKind = "title-element-kind"
    
    // MARK: - Function
    private func createLayout() -> UICollectionViewLayout {
        let estimatedValueSize: CGFloat = 12.0
        let itemMargin: CGFloat =  12.0
        let groupMargin: CGFloat =  12.0
        let headerHeight: CGFloat =  36.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedValueSize),
                                              heightDimension: .estimated(estimatedValueSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedValueSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(itemMargin)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = groupMargin
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setHierarchy() {
        addedTagCollectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: addedTagCollectionView) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: String) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
                fatalError("err")
            }
            cell.setData(value: "\(identifier)")
            return cell
        }
        applyInitialDataSource()
    }
    
    private func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sampleArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
