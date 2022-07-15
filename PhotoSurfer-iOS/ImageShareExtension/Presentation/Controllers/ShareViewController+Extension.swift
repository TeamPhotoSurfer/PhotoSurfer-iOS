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
        let estimatedValueSize: CGFloat = 1.0
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
        let layout = UICollectionViewCompositionalLayout { section, env in
            createdSection.orthogonalScrollingBehavior = (section == 0) ? .continuous : .none
            return createdSection
        }
        return layout
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
            var headerTitle: String = "입력한 태그"
            guard let header = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: TagsHeaderCollectionReusableView.identifier,
                                                  for: indexPath) as? TagsHeaderCollectionReusableView else {
                fatalError()
            }
            print("yuyuyu \(indexPath.section)")
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
                    if self.typingTextCount == 0 {
                        self.relatedTags = self.relatedTagsFetched
                    }
                }
            }
            header.platformDescriptionLabel.isHidden = true
            header.setData(value: headerTitle)
            return header
        }
        applyChangedDataSource(inputText: typingText, isEmpty: !isSearching)
    }
    
    private func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.addedTag, .recentTag, .oftenTag, .platformTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(recentTags, toSection: .recentTag)
        snapshot.appendItems(oftenTags, toSection: .oftenTag)
        snapshot.appendItems(platformTags, toSection: .platformTag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyChangedDataSource(inputText: String, isEmpty: Bool) {
        var snapshot2 = NSDiffableDataSourceSnapshot<Section, String>()
        relatedTags = relatedTags.filter({ $0.contains(inputText) })
        snapshot2.appendSections([.addedTag , .relatedTag])
        snapshot2.appendItems(addedTags, toSection: .addedTag)
        snapshot2.appendItems(relatedTags, toSection: .relatedTag)
        //여긴가 (dataSource)
        dataSource.apply(snapshot2, animatingDifferences: true)
    }
}

extension ShareViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        typingButton.setTitle(searchText, for: .normal)
        typingText = searchText
        if typingTextCount > searchText.count {
            print("relatedTagsFetched\(relatedTagsFetched)")
            relatedTags = relatedTagsFetched.filter({ $0.contains(searchText) })
            print("relatedTagsFetched\(relatedTagsFetched)")
        }
        typingTextCount = searchText.count
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            setSupplementaryViewProvider(dataSource: setDataSource())
            relatedTags = relatedTagsFetched
            isTyping = false
            return
        }
        // 질문
        setSearchSupplementaryViewProvider(dataSource: setDataSource(), isSearching: true)
        if searchText.count >= 1 {
            isTyping = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            setSupplementaryViewProvider(dataSource: setDataSource())
            return
        }
    }
}

extension ShareViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("aaa")
    }
}
