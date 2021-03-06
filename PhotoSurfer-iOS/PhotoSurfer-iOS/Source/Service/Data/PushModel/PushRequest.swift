//
//  PushRequest.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/20.
//

import Foundation

struct PushAlarmRequest {
    let memo: String
    let pushDate: String
    let tagIDs: [Int]
    
    enum CodingKeys: String, CodingKey {
        case memo, pushDate
        case tagIds = "tagIDs"
    }
}
