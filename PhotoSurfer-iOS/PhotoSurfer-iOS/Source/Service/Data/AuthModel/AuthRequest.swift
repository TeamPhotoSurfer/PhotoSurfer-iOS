//
//  AuthRequest.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation

struct AuthRequest {
    let socialToken: String
    let socialType: String = "kakao"
    let fcm: String = "a"
    
    enum CodingKeys: String, CodingKey {
        case socialToken
        case socialType
        case fcm
    }
}
