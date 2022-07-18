//
//  URLConstant.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/17.
//

import Foundation

struct URLConstant {
    
    // MARK: - Base
    static let baseURL = ""
    
    // MARK: - Auth
    static let authLogin = "/auth/login"
    
    // MARK: - Tag
    static let tagMain = "/tag/main"
    static let tagSearch = "/tag/search"
    static let tag = "/tag"
    static let tagBookmark = "/tag/bookmark"
    
    // MARK: - Photo
    static let photo = "/photo"
    static let photoTag = "/photo/tag"
    static let photoPush = "/photo/push"
    
    // MARK: - Push
    static let push = "/push"
    static let pushLast = "/push/last"
    static let pushCome = "/push/come"
    static let pushToday = "/push/today"
}
