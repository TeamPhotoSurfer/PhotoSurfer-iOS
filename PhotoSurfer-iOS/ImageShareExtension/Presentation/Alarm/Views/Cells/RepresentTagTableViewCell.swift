//
//  RepresentTagTableViewCell.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/18.
//

import UIKit

final class RepresentTagTableViewCell: UITableViewCell {

    // MARK: - Property
    static let identifier = "RepresentTagTableViewCell"
    
    // MARK: - IBAction
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        checkButton.setBackgroundImage(Const.Image.icCircleLine, for: .normal)
        checkButton.setBackgroundImage(Const.Image.icCheckCircleFill, for: .selected)
    }
}
