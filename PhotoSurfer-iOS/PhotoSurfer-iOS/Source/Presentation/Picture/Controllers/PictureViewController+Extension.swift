//
//  PictureViewController+Extension.swift
//  PhotoSurfer-iOS
//xx
//  Created by 김혜수 on 2022/07/19.
//

import UIKit

extension PictureViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if editMode == .add {
            if !(textField.text?.isEmpty ?? true) && tags.count < 6 {
                tags.insert(Tag(name: textField.text ?? ""), at: 0)
                addPhotoTag(tagName: textField.text ?? "")
                applyTagsSnapshot()
            }
        }
        else if editMode == .edit {
            if !(textField.text?.isEmpty ?? true) {
                if let editIdx = editIdx, let tagId = tags[editIdx].id {
                    putPhotoTag(editIdx: editIdx, tagId: tagId, name: textField.text ?? "")
                }
            }
        }
        return true
    }
}

extension PictureViewController: UICollectionViewDelegate {
    
    private func alertDeleteTag(idx: Int) {
        if tags.count == 1 {
            self.makeRequestAlert(title: "\(tags[idx].name)태그를 삭제하시겠습니까?",
                                  message: "마지막 태그를 삭제하면 사진도 포토서퍼에서 지워집니다", okAction: { _ in
                if let id = self.tags[idx].id {
                    self.deletePhotoTag(tagId: id)
                }
                self.tags.remove(at: idx)
                
                self.navigationController?.popViewController(animated: true)
            }, completion: nil)
        } else {
            self.makeRequestAlert(title: "",
                                  message: "\(tags[idx].name)태그를 삭제하시겠습니까?", okAction: { _ in
                if let id = self.tags[idx].id {
                    self.deletePhotoTag(tagId: id)
                }
                self.tags.remove(at: idx)
                
                self.applyTagsSnapshot()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editMode == .delete {
            alertDeleteTag(idx: indexPath.item)
        }
        else if editMode == .edit {
            setDataSource(isDeletable: false, editIdx: indexPath.item)
            editIdx = indexPath.item
            applyTagsSnapshot()
            keyboardTopTextField.becomeFirstResponder()
        }
    }
}

extension PictureViewController {
    
    func deletePhotoTag(tagId: Int) {
        guard let photoID = photoID else { return }
        PhotoService.shared.deletePhotoMenuTag(tagId: tagId, photoIds: [photoID]) { response in
            switch response {
            case .success(let data):
                print(data)
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func addPhotoTag(tagName: String) {
        guard let photoID = photoID else { return }
        PhotoService.shared.postAddPhotoMenuTag(photoIds: [photoID], name: tagName, type: .general) { response in
            switch response {
            case .success(let data):
                print(data)
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func putPhotoTag(editIdx: Int, tagId: Int, name: String) {
        guard let photoID = photoID else { return }
        PhotoService.shared.putPhotoMenuTag(tagId: tagId, name: name, type: .general, photoIds: [photoID]) { response in
            switch response {
            case .success(let data):
                print(data)
                self.tags[editIdx] = (Tag(name: name))
                self.applyTagsSnapshot()
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
