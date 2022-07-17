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
        let layout = UICollectionViewCompositionalLayout { selectedSection, env in
            let estimatedValueSize: CGFloat = 1.0
            let itemMargin: CGFloat =  12.0
            let groupSizeWidth: NSCollectionLayoutDimension = (selectedSection == 0) ? .estimated(1.0) : .fractionalWidth(1.0)
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedValueSize),
                                                  heightDimension: .estimated(estimatedValueSize))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: groupSizeWidth,
                                                   heightDimension: .estimated(estimatedValueSize))
            var group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            if self.dataSource.snapshot().numberOfSections > 3 {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            }
            else {
                switch selectedSection {
                case 0 :
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                default :
                    group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitems: [item])
                }
            }
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
            section.orthogonalScrollingBehavior = (selectedSection == 0) ? .continuous : .none
            return section
        }
        return layout
    }
        
    func setHierarchy() {
        addedTagCollectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    func setDataSource() -> UICollectionViewDiffableDataSource<Section, Tag> {
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: addedTagCollectionView) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: Tag) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                                for: indexPath) as? TagCollectionViewCell else {
                fatalError("err")
            }
            cell.setUI(isAddedTag: indexPath.section == 0)
            cell.setData(value: "\(identifier.title)")
            return cell
        }
        return dataSource
    }
    
    func setSupplementaryViewProvider(dataSource: UICollectionViewDiffableDataSource<Section, Tag>) {
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
    
    func setSearchSupplementaryViewProvider(dataSource: UICollectionViewDiffableDataSource<Section, Tag>, isSearching: Bool) {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.addedTag, .recentTag, .oftenTag, .platformTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(recentTags, toSection: .recentTag)
        snapshot.appendItems(oftenTags, toSection: .oftenTag)
        snapshot.appendItems(platformTags, toSection: .platformTag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyChangedDataSource(inputText: String, isEmpty: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        for tag in relatedTags {
            print(tag.title)
        }
        print(relatedTags)
        relatedTags = relatedTags.filter({ $0.title.contains(inputText) })
        for tag in relatedTags {
            print(tag.title)
        }
        snapshot.appendSections([.addedTag , .relatedTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(relatedTags, toSection: .relatedTag)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ShareViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        typingButton.setTitle(searchText, for: .normal)
        typingText = searchText
        typingTextCount = searchText.count
        relatedTags = relatedTagsFetched.filter({ $0.title.contains(searchText) })
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            setSupplementaryViewProvider(dataSource: setDataSource())
            relatedTags = relatedTagsFetched
            isTyping = false
            typingButton.isHidden = true
            return
        }
        typingButton.isHidden = false
        setSearchSupplementaryViewProvider(dataSource: setDataSource(), isSearching: true)
        if searchText.count >= 1 {
            isTyping = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            typingButton.isHidden = true
            return
        }
        if !addedTags.contains(Tag(title: typingText)) {
            if addedTags.count >= 6 {
                makeToast(message: self.underSixTagMessage)
            }
            else {
                addedTags.append(Tag(title: typingText))
                relatedTags.append(Tag(title: typingText))
                applyChangedDataSource(inputText: typingText, isEmpty: false)
            }
        }
        else {
            makeToast(message: alreadyAddedMessage)
        }
    }
}

extension ShareViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if dataSource.snapshot().numberOfSections <= 2 {
            didSelectItemSearching(indexPath: indexPath)
        }
        else {
            didSelectItemSaved(indexPath: indexPath)
            applyInitialDataSource()
        }
    }
    
    private func didSelectItemSearching(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            addedTags.remove(at: indexPath.item)
        default:
            addTag(indexPath: indexPath, tagType: relatedTags)
        }
        applyChangedDataSource(inputText: "", isEmpty: true)
    }
    
    private func didSelectItemSaved(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            addedTags.remove(at: indexPath.item)
        case 1:
            addTag(indexPath: indexPath, tagType: recentTags)
        case 2:
            addTag(indexPath: indexPath, tagType: oftenTags)
        default:
            addTag(indexPath: indexPath, tagType: platformTags)
        }
    }
    
    private func addTag(indexPath: IndexPath, tagType: [Tag]) {
        var isAddedTagContainItem: Bool = false
        for i in 0..<addedTags.count {
            isAddedTagContainItem = (addedTags[i].title == tagType[indexPath.item].title)
        }
        if !isAddedTagContainItem {
            if addedTags.count >= 6 {
                makeToast(message: underSixTagMessage)
            }
            else {
                addedTags.append(Tag(title: tagType[indexPath.item].title))
            }
        }
        else {
            makeToast(message: alreadyAddedMessage)
        }
    }
}

extension ShareViewController: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       typingButtonTopConstraint.constant = typingButtonTopConstValue + scrollView.contentOffset.y
   }
}
