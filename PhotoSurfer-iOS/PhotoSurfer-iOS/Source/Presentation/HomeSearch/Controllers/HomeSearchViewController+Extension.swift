//
//  HomeSearchViewController+Extension.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/12.
//

import UIKit

extension HomeSearchViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIdx, env in
            return self.createSectionLayout(groupWidth: (sectionIdx == 0) ? .estimated(100) :
                                                ((self.isShownRelated) ? .estimated(100) : .fractionalWidth(1.0)),
                                            scrollBehavior: (sectionIdx == 0) ? .continuous : .none)
        }
        return layout
    }
    
    
    private func createSectionLayout(groupWidth: NSCollectionLayoutDimension,
                                     scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: groupWidth,
            heightDimension: .absolute(34))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 20, bottom: 8, trailing: 20)
        section.orthogonalScrollingBehavior = scrollBehavior
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(48))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func applyInitialDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        collectionViewHeaders = ["μλ ₯ν νκ·Έ", "μ΅κ·Ό μΆκ°ν νκ·Έ", "μμ£Ό μΆκ°ν νκ·Έ", "νλ«νΌ νκ·Έ"]
        snapshot.appendSections([.inputTag, .recentAddTag, .frequencyAddTag, .platformTag])
        snapshot.appendItems(inputTags, toSection: .inputTag)
        snapshot.appendItems(recentTags, toSection: .recentAddTag)
        snapshot.appendItems(frequencyTags, toSection: .frequencyAddTag)
        snapshot.appendItems(platformTags, toSection: .platformTag)
        dataSource.apply(snapshot)
    }
    
    private func applyRelatedTagSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        collectionViewHeaders = ["μλ ₯ νκ·Έ", "μ°κ΄ νκ·Έ"]
        snapshot.appendSections([.inputTag, .relatedTag])
        snapshot.appendItems(inputTags, toSection: .inputTag)
        snapshot.appendItems(relatedTags, toSection: .relatedTag)
        dataSource.apply(snapshot)
    }
}

extension HomeSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            inputTags.remove(at: indexPath.item)
        case 1:
            if inputTags.count < 6 {
                if isShownRelated {
                    if !inputTags.contains(where: { $0.id == relatedTags[indexPath.item].id }) {
                        inputTags.append(Tag(id: relatedTags[indexPath.item].id,
                                             name: relatedTags[indexPath.item].name))
                    }
                } else {
                    if !inputTags.contains(where: { $0.id == recentTags[indexPath.item].id }) {
                        inputTags.append(Tag(id: recentTags[indexPath.item].id,
                                             name: recentTags[indexPath.item].name))
                    }
                }
            }
        case 2:
            if inputTags.count < 6, !inputTags.contains(where: { $0.id == frequencyTags[indexPath.item].id }) {
                inputTags.append(Tag(id: frequencyTags[indexPath.item].id, name: frequencyTags[indexPath.item].name))
            }
        case 3:
            if inputTags.count < 6, !inputTags.contains(where: { $0.id == platformTags[indexPath.item].id }) {
                inputTags.append(Tag(id: platformTags[indexPath.item].id, name: platformTags[indexPath.item].name))
            }
        default:
            print("none")
        }
        setDataSource()
        searchBar.text == "" ? applyInitialDataSource() : applyRelatedTagSnapshot()
    }
}

extension HomeSearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if inputTags.count > 0 {
            goToSearchResultViewController(tags: inputTags)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isShownRelated = (searchBar.text != "")
        relatedTags = []
        if searchText.isEmpty {
            applyInitialDataSource()
        }
        else {
            for tag in allTags where tag.name.lowercased().contains(searchText.lowercased()) {
                relatedTags.append(Tag(id: tag.id, name: tag.name))
            }
            applyRelatedTagSnapshot()
        }
    }
}
