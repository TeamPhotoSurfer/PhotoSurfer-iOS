//
//  AlarmListTableViewCell.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/18.
//

import UIKit

final class AlarmListTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        photoImageView.layer.cornerRadius = 8
    }
    
    func setData(push: Push) {
        photoImageView.setImage(with: push.imageURL ?? "")
        var tagText = ""
        for tag in push.tags {
            tagText += "#\(tag) "
        }
        tagLabel.text = tagText
        dateLabel.text = push.pushDate
        memoLabel.text = push.memo
    }
}
