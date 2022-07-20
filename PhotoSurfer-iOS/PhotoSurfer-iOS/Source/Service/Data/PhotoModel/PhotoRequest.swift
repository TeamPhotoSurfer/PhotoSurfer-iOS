//
//  PhotoRequest.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import UIKit

struct PhotoRequest {
    let file: UIImage
    let tags: [Tag]
    
    enum CodingKeys: String, CodingKey {
        case file
        case tags
    }
}
