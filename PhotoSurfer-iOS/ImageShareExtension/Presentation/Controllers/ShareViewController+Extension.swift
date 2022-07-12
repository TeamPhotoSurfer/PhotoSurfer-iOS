//
//  ShareViewController+Extension.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/12.
//

import UIKit

extension ShareViewController {
    
    // MARK: - Property
    static let sectionHeaderElementKind = "section-header-element-kind"
    
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        
        /// header
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: ShareViewController.sectionHeaderElementKind, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
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
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            var headerTitle: String = "입력한 태그"
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: ShareViewController.sectionHeaderElementKind, withReuseIdentifier: TagsHeaderCollectionReusableView.identifier, for: indexPath) as? TagsHeaderCollectionReusableView else { fatalError() }
            
            switch indexPath.section {
            case 0:
                headerTitle = "추가한 태그"
            case 1:
                headerTitle = "최근 추가한 태그"
            case 2:
                headerTitle = "자주 추가한 태그"
            default:
                headerTitle = "플랫폼 유형"
            }
            
            if indexPath.section != 0 {
                header.setNotInputTagHeader()
                header.underSixLabel.isHidden = true
            }
            else {
                header.underSixLabel.isHidden = false
            }
            
            if indexPath.section != 3 {
                header.platformDescriptionLabel.isHidden = true
            }
            else {
                header.platformDescriptionLabel.isHidden = false
            }
            header.setData(value: headerTitle)
            return header
        }
        applyInitialDataSource()
    }
    
    private func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.addedTag, .recentTag, .oftenTag, .platformTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(recentTags, toSection: .recentTag)
        snapshot.appendItems(oftenTags, toSection: .oftenTag)
        snapshot.appendItems(platformTags, toSection: .platformTag)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySearchDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.addedTag, .relatedTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(relatedTags, toSection: .relatedTag)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func changeDataSource(inputText: String) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        relatedTags = relatedTags.filter({ $0.contains(inputText) })
        snapshot.reloadItems(relatedTags)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ShareViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEditing")
        
        applySearchDataSource()
        
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dissmissKeyboard()
        
        guard let inputText = searchBar.text, !inputText.isEmpty else { return }
        changeDataSource(inputText: inputText)
        
        print("검색어: \(inputText)")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChanged")
    }
    
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
