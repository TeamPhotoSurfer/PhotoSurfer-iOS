//
//  HomeSearchViewController+Extension.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/12.
//

import UIKit

extension HomeSearchViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 20, bottom: 8, trailing: 20)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(48))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                   layoutSize: headerSize,
                   elementKind: UICollectionView.elementKindSectionHeader,
                   alignment: .top)
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension HomeSearchViewController: UISearchBarDelegate {
    
    
}
