//
//  SetRepresentTagViewController+Extension.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/18.
//

import UIKit

extension SetRepresentTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepresentTagTableViewCell.identifier) as? RepresentTagTableViewCell else {
            return UITableViewCell()
        }
        cell.tagButton.setTitle(tags[indexPath.row].title, for: .normal)
        cell.selectButton.addTarget(self, action: #selector(self.selectButtonDidTap),
                                    for: .touchUpInside)
        return cell
    }
    
    private func addSelectedTags(indexPath: IndexPath, cell: RepresentTagTableViewCell) {
        
        if selectedTags.count >= 3 {
            if selectedTags.contains(tags[indexPath.item]) {
                removeSelectedTag(indexPath: indexPath, cell: cell)
            }
            else {
                showAlert(message: "대표 태그는 최대 3개까지 선택할 수 있어요.")
            }
        }
        else if !selectedTags.isEmpty {
            if selectedTags.contains(tags[indexPath.item]) {
                removeSelectedTag(indexPath: indexPath, cell: cell)
            }
            else {
                addSelectedTag(indexPath: indexPath, cell: cell)
            }
        }
        else {
            addSelectedTag(indexPath: indexPath, cell: cell)
        }
    }
    
    private func addSelectedTag(indexPath: IndexPath, cell: RepresentTagTableViewCell) {
        cell.checkButton.isSelected = true
        selectedTags.append(tags[indexPath.item])
        saveButton.isEnabled = !selectedTags.isEmpty
    }
    
    private func removeSelectedTag(indexPath: IndexPath, cell: RepresentTagTableViewCell) {
        for i in 0..<selectedTags.count {
            if selectedTags[i] == tags[indexPath.item] {
                cell.checkButton.isSelected = false
                selectedTags.remove(at: i)
                break
            }
        }
        saveButton.isEnabled = !selectedTags.isEmpty
    }
    
    // MARK: - Objc Function
    @objc func selectButtonDidTap(sender: UIButton) {
        var superview = sender.superview
        while superview != nil {
            if let cell = superview as? RepresentTagTableViewCell {
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                addSelectedTags(indexPath: indexPath, cell: cell)
                break
            }
            superview = superview?.superview
        }
    }
}

protocol SetSelectedRepresentTag {
    func sendSelectedRepresentTag(tags: [Tag])
}
