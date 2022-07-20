//
//  PictureViewController+Extension.swift
//  PhotoSurfer-iOS
//xx
//  Created by 김혜수 on 2022/07/19.
//

import UIKit

extension PictureViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty ?? true) && tags.count < 6 {
            tags.insert(Tag(name: textField.text ?? ""), at: 0)
            applyTagsSnapshot()
        }
        return true
    }
}

extension PictureViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editMode == .delete {
            if tags.count == 1 {
                self.makeRequestAlert(title: "\(tags[indexPath.item].name)태그를 삭제하시겠습니까?",
                                      message: "마지막 태그를 삭제하면 사진도 포토서퍼에서 지워집니다", okAction: { _ in
                    self.tags.remove(at: indexPath.item)
                    self.navigationController?.popViewController(animated: true)
                }, completion: nil)
            } else {
                self.makeRequestAlert(title: "",
                                      message: "\(tags[indexPath.item].name)태그를 삭제하시겠습니까?", okAction: { _ in
                    self.tags.remove(at: indexPath.item)
                    self.applyTagsSnapshot()
                }, completion: nil)
            }
            
        }
    }
}
