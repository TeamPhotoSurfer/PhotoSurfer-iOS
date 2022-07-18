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
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        photoImageView.layer.cornerRadius = 8
    }
}
