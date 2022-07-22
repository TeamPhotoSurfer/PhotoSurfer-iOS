//
//  AuthResponse.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation

struct AuthResponse: Codable {
    let checkUser: CheckUser
    let accesstoken: String
}

// MARK: - CheckUser
struct CheckUser: Codable {
    let id: Int
    let updatedAt, createdAt, name: String?
    let email, socialType, fcmToken: String
    let push, isDeleted: Bool
}
