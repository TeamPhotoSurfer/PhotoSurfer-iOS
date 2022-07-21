//
//  PushRequest.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation

struct PushAlarmRequst {
    let memo: String
    let pushDate: String
    let tagIDs: [Int]
    
    enum CodingKeys: String, CodingKey {
        case memo, pushDate
        case tagIds = "tagIDs"
    }
}
