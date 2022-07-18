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
            let groupSizeWidth: NSCollectionLayoutDimension = (selectedSection == 0) ? .estimated(1.0) : .fractionalWidth(1.0)
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                                  heightDimension: .estimated(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: groupSizeWidth,
                                                   heightDimension: .estimated(1))
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
            group.interItemSpacing = .fixed(12)
            
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 60, trailing: 0)
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
            cell.setUI(isAddedTag: indexPath.section == 0, value: identifier.title)
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
    
    func setSearchSupplementaryViewProvider(dataSource: UICollectionViewDiffableDataSource<Section, Tag>) {
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
                    if self.typingTextCount == 0 {
                        self.relatedTags = self.relatedTagsFetched
                    }
                }
            }
            header.platformDescriptionLabel.isHidden = true
            header.setData(value: headerTitle)
            return header
        }
        print("🤥 \(typingText)")
        applyChangedDataSource(inputText: typingText)
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
    
    private func applyChangedDataSource(inputText: String) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        relatedTags = relatedTags.filter({ $0.title.contains(inputText) })
        snapshot.appendSections([.addedTag , .relatedTag])
        snapshot.appendItems(addedTags, toSection: .addedTag)
        snapshot.appendItems(relatedTags, toSection: .relatedTag)
        dataSource.apply(snapshot, animatingDifferences: false)
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
            typingView.isHidden = true
            return
        }
        typingView.isHidden = false
        if searchText.count >= 1 {
            isTyping = true
        }
        applyChangedDataSource(inputText: inputText)
        //4setSearchSupplementaryViewProvider(dataSource: setDataSource())
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text, !inputText.isEmpty else {
            typingView.isHidden = true
            return
        }
        if !addedTags.contains(Tag(title: typingText)) {
            if addedTags.count >= 6 {
                showAlert(message: self.underSixTagMessage)
            }
            else {
                addedTags.append(Tag(title: typingText))
                if addedTags.count <= 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.typingViewTopConstraint.constant = self.typingButtonTopConstValue
                    }
                }
                relatedTags.append(Tag(title: typingText))
                applyChangedDataSource(inputText: typingText)
            }
        }
        else {
            showAlert(message: alreadyAddedMessage)
        }
    }
}

extension ShareViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if dataSource.snapshot().numberOfSections <= 2 {
            didSelectItemSearching(indexPath: indexPath, collectionView: collectionView)
        }
        else {
            didSelectItemSaved(indexPath: indexPath, collectionView: collectionView)
        }
    }
    
    private func didSelectItemSearching(indexPath: IndexPath, collectionView: UICollectionView) {
        switch indexPath.section {
        case 0:
            addedTags.remove(at: indexPath.item)
            setTagUI(indexPath: indexPath, collectionView: collectionView, isAdded: false)
            if addedTags.count <= 0 {
                UIView.animate(withDuration: 0.5) {
                    self.typingViewTopConstraint.constant += 34
                }
            }
        default:
            addTag(indexPath: indexPath, tagType: relatedTags, collectionView: collectionView)
        }
        applyChangedDataSource(inputText: "")
    }
    
    private func didSelectItemSaved(indexPath: IndexPath, collectionView: UICollectionView) {
        switch indexPath.section {
        case 0:
            setDeselectedTagUI(indexPath: indexPath, collectionView: collectionView)
            addedTags.remove(at: indexPath.item)
            if addedTags.count <= 0 {
                UIView.animate(withDuration: 0.5) {
                    self.typingViewTopConstraint.constant += 34
                }
            }
        case 1:
            addTag(indexPath: indexPath, tagType: recentTags, collectionView: collectionView)
        case 2:
            addTag(indexPath: indexPath, tagType: oftenTags, collectionView: collectionView)
        default:
            addTag(indexPath: indexPath, tagType: platformTags, collectionView: collectionView)
        }
        applyInitialDataSource()
    }
    
    private func addTag(indexPath: IndexPath, tagType: [Tag], collectionView: UICollectionView) {
        var isAddedTagContainItem: Bool = false
        for i in 0..<addedTags.count {
            isAddedTagContainItem = (addedTags[i].title == tagType[indexPath.item].title)
        }
        if !isAddedTagContainItem {
            if addedTags.count >= 6 {
                showAlert(message: underSixTagMessage)
            }
            else {
                addedTags.append(Tag(title: tagType[indexPath.item].title))
                setTagUI(indexPath: indexPath, collectionView: collectionView, isAdded: true)
                if addedTags.count <= 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.typingViewTopConstraint.constant = self.typingButtonTopConstValue
                    }
                }
            }
        }
        else {
            showAlert(message: alreadyAddedMessage)
        }
    }
    
    private func setTagUI(indexPath: IndexPath, collectionView: UICollectionView, isAdded: Bool) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell else {
            return
        }
        cell.setClickedTagUI(isAdded: isAdded)
    }
    
    private func setDeselectedTagUI(indexPath: IndexPath, collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell else {
            return
        }
        let selectedTagText = cell.tagNameButton.titleLabel?.text
        let allTags: [[Tag]] = [recentTags, oftenTags, platformTags]
        
        for tags in allTags {
            for index in 0..<tags.count {
                if tags[index].title == selectedTagText {
                    switch tags {
                    case recentTags:
                        setTagUI(indexPath: IndexPath(item: index, section: 1), collectionView: collectionView, isAdded: false)
                    case oftenTags:
                        setTagUI(indexPath: IndexPath(item: index, section: 2), collectionView: collectionView, isAdded: false)
                    case platformTags:
                        setTagUI(indexPath: IndexPath(item: index, section: 3), collectionView: collectionView, isAdded: false)
                    default:
                        return
                    }
                }
            }
        }
    }
}

extension ShareViewController: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       typingViewTopConstraint.constant = typingButtonTopConstValue + scrollView.contentOffset.y
   }
}
