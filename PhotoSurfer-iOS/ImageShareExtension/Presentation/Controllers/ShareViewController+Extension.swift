//
//  ShareViewController+Extension.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/12.
//

import UIKit

extension ShareViewController {
    
    // MARK: - Function
    private func createLayout() -> UICollectionViewLayout {
        let estimatedValueSize: CGFloat = 12.0
        let itemMargin: CGFloat =  12.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedValueSize),
                                              heightDimension: .estimated(estimatedValueSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedValueSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(itemMargin)
        
        /// header
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        let groupMargin: CGFloat =  12.0
        section.interGroupSpacing = groupMargin
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        return createCollectionViewLayout(createdSection: section)
    }
    
    private func createCollectionViewLayout(createdSection: NSCollectionLayoutSection) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self.createContinuousSectionLayout(section: createdSection)
            default:
                return self.createFixedSectionLayout(section: createdSection)
            }
        }
    }
    
    private func createContinuousSectionLayout(section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createFixedSectionLayout(section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        section.orthogonalScrollingBehavior = .none
        return section
    }
    
    func setHierarchy() {
        addedTagCollectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    func setDataSource() -> UICollectionViewDiffableDataSource<Section, String> {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: addedTagCollectionView) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: String) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                                for: indexPath) as? TagCollectionViewCell else {
                fatalError("err")
            }
            cell.setData(value: "\(identifier)")
            return cell
        }
        return dataSource
    }
    
    func setSupplementaryViewProvider(dataSource: UICollectionViewDiffableDataSource<Section, String>) {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            var headerTitle: String = "입력한 태그"
            guard let header = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: TagsHeaderCollectionReusableView.identifier,
                                                  for: indexPath) as? TagsHeaderCollectionReusableView else {
                fatalError()
            }
            headerTitle = self.headerTitleArray[indexPath.section]
            
            if indexPath.section != 0 {
                header.setNotInputTagHeader()
                header.underSixLabel.isHidden = true
            }
            else {
                header.underSixLabel.isHidden = false
            }
            header.setRelatedTagInputView(isRelatedTag: false)
            header.platformDescriptionLabel.isHidden = (indexPath.section != 3)
            header.setData(value: headerTitle)
            return header
        }
        applyInitialDataSource()
    }
    
    func setSearchSupplementaryViewProvider(dataSource: UICollectionViewDiffableDataSource<Section, String>, isSearching: Bool) {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            print("a")
            var headerTitle: String = "입력한 태그"
            guard let header = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: TagsHeaderCollectionReusableView.identifier,
                                                  for: indexPath) as? TagsHeaderCollectionReusableView else {
                fatalError()
            }
            if indexPath.section == 0 {
                header.setInputTagHeader()
                header.setRelatedTagInputView(isRelatedTag: false)
                headerTitle = self.searchHeaderTitleArray[0]
            }
            else {
                header.setNotInputTagHeader()
                header.setRelatedTagInputView(isRelatedTag: true)
                headerTitle = self.searchHeaderTitleArray[1]
                if self.isTyping {
                    print("self.typingText \(self.typingText)")
                    header.setInputText(inputText: self.typingText)
                }
            }
            header.platformDescriptionLabel.isHidden = true
            header.setData(value: headerTitle)
            print("1")
            return header
        }
        print("2")
        applyChangedDataSource(inputText: "", isEmpty: !isSearching)
        print("3")
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
    
    private func applyChangedDataSource(inputText: String, isEmpty: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        if !isEmpty {
            relatedTags = relatedTags.filter({ $0.contains(inputText) })
        }
        snapshot.appendSections([.addedTag , .relatedTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(relatedTags, toSection: .relatedTag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ShareViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            setSupplementaryViewProvider(dataSource: setDataSource())
            print("searchBarShouldBeginEditing")
            return true
        }
        print("searchBarShouldBeginEditing")
        setSearchSupplementaryViewProvider(dataSource: setDataSource(), isSearching: true)
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            setSupplementaryViewProvider(dataSource: setDataSource())
            isTyping = false
            print("searchBarShouldBeginEditing")
            return
        }
        // 질문
        setSearchSupplementaryViewProvider(dataSource: setDataSource(), isSearching: true)
        print("textDidChange")
        if searchText.count >= 1 {
            isTyping = true
            typingText = searchText
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarShouldBeginEditing")
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            setSupplementaryViewProvider(dataSource: setDataSource())
            return
        }
    }
}
