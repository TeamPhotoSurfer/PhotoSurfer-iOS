//
//  HomeViewController+Extension.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/14.
//

import UIKit

extension HomeViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(86),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        group.interItemSpacing = .fixed(14)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToHomeSearchViewController(inputTags: [tags[indexPath.item]])
    }
}
