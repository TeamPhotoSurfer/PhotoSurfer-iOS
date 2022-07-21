//
//  SetAlarmViewController+Extension.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/18.
//

import UIKit

extension SetAlarmViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = ""
            textView.textColor  = .grayGray90
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grayGray50
        }
    }
}

extension SetAlarmViewController: SetSelectedRepresentTag {
    func sendSelectedRepresentTag(tags: [Tag]) {
        representTag = tags
        var selectedTag: String = ""
        for index in 0..<representTag.count {
            switch index {
            case tags.count-1:
                selectedTag += "#\(tags[index].name)"
            default:
                selectedTag += "#\(tags[index].name), "
            }
        }
        setRepresentTagButton.setTitle(selectedTag, for: .normal)
    }
}
