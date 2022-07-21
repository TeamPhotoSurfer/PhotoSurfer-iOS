//
//  HomeResultViewController+Extension.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/16.
//

import UIKit

extension HomeResultViewController {
    
    func createTagsLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 6
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createPhotosLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension HomeResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editMode == .none {
            if isMultiSelectMode {
                if selectedPhotos.contains(where: {$0.id == photos[indexPath.item].id }) {
                    selectedPhotos = selectedPhotos.filter {
                        $0.id != photos[indexPath.item].id
                    }
                    print(selectedPhotos)
                }
                else {
                    selectedPhotos.append(photos[indexPath.item])
                }
                setDataSource()
                applyTagSnapshot()
                applyPhotoSnapshot()
            } else {
                if collectionView === tagCollectionView {
                    tags.remove(at: indexPath.item)
                    getPhotoSearch()
                    applyTagSnapshot()
                }
                else {
                    goToPictureViewController(photoId: photos[indexPath.item].id)
                }
            }
        }
    }
}
