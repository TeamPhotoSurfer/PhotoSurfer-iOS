//
//  AlarmListSectionHeaderView.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/18.
//

import UIKit

final class AlarmListSectionHeaderView: UIView {
    
    // MARK: - Component
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .iosCaption1
        label.textColor = .grayGray90
        return label
    }()
    
    // MARK: - LifeCycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        setLayout()
        setTitle(title)
    }
    
    // MARK: - Function
    private func setLayout() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
