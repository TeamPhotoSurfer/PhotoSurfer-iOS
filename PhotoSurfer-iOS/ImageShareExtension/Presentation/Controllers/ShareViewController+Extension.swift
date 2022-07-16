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
            switch indexPath.section {
            case 0 :
                cell.deleteImageView.isHidden = false
                cell.backgroundImageButton.setBackgroundImage(Const.Image.colorMain, for: .normal)
                cell.tagNameButton.setTitleColor(.grayWhite, for: .normal)
            default:
                cell.deleteImageView.isHidden = true
                cell.backgroundImageButton.setBackgroundImage(Const.Image.colorSub, for: .normal)
                cell.tagNameButton.setTitleColor(.pointMain, for: .normal)
            }
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
        var snapshot2 = NSDiffableDataSourceSnapshot<Section, Tag>()
        relatedTags = relatedTags.filter({ $0.title.contains(inputText) })
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
            relatedTags = relatedTagsFetched.filter({ $0.title.contains(searchText) })
        }
        typingTextCount = searchText.count
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
                self.view.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
            }
            else {
                addedTags.append(Tag(title: typingText))
                relatedTags.append(Tag(title: typingText))
                applyChangedDataSource(inputText: typingText, isEmpty: false)
            }
        }
    }
}

extension ShareViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSource.snapshot().numberOfSections <= 2 {
            switch indexPath.section {
            case 0:
                addedTags.remove(at: indexPath.item)
            default:
                if !addedTags.contains(relatedTags[indexPath.item]) {
                    if addedTags.count >= 6 {
                        self.view.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
                    }
                    else {
                        addedTags.append(relatedTags[indexPath.item])
                        relatedTags.append(Tag(title: typingText))
                    }
                }
            }
            applyChangedDataSource(inputText: typingText, isEmpty: true)
        }
        else {
            switch indexPath.section {
            case 0:
                addedTags.remove(at: indexPath.item)
            case 1:
                if !addedTags.contains(recentTags[indexPath.item]) {
                    if addedTags.count >= 6 {
                        self.view.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
                    }
                    else {
                        addedTags.append(recentTags[indexPath.item])
                    }
                }
            case 2:
                if !addedTags.contains(oftenTags[indexPath.item]) {
                    if addedTags.count >= 6 {
                        self.view.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
                    }
                    else {
                        addedTags.append(oftenTags[indexPath.item])
                    }
                }
            default:
                if !addedTags.contains(platformTags[indexPath.item]) {
                    if addedTags.count >= 6 {
                        let windows = UIWindowScene.window
                        
                        windows.last?.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
                        self.view.makeToast("태그는 최대 6개까지만 추가할 수 있어요.")
                    }
                    else {
                        addedTags.append(platformTags[indexPath.item])
                    }
                }
            }
            applyInitialDataSource()
        }
        for tag in addedTags {
            print("tag.title \(tag.title)")            
        }
    }
}
