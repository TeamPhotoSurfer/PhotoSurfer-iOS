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
    
    
    private func applyRelatedTagSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        collectionViewHeaders = ["입력 태그", "연관 태그"]
        snapshot.appendSections([.inputTag, .relatedTag])
        snapshot.appendItems(inputTags, toSection: .inputTag)
        snapshot.appendItems(relatedTags, toSection: .relatedTag)
        dataSource.apply(snapshot)
    }
}

extension HomeSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Section(rawValue: indexPath.section) == .inputTag {
            inputTags.remove(at: indexPath.item)
            searchBar.text?.isEmpty ?? true ? applyInitialDataSource() : applyRelatedTagSnapshot()
        }
    }
}

extension HomeSearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if inputTags.count < 6 && !text.isEmpty {
                inputTags.append(Tag(title: searchBar.text ?? ""))
                searchBar.text?.removeAll()
                applyInitialDataSource()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchText.isEmpty ? applyInitialDataSource() : applyRelatedTagSnapshot()
    }
}
