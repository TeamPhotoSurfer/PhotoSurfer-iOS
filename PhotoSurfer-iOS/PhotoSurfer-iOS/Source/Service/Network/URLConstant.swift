//
//  URLConstant.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/17.
//

import Foundation

struct URLConstant {
    
    // MARK: - Base
    static let baseURL = "http://52.78.96.21:8000"
    
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
    static let photoSearch = "/photo/search"
    static let photoDetail = "/photo/detail"
    static let photoMenuTag = "/photo/menu/tag"
    
    // MARK: - Push
    static let push = "/push"
    static let pushListLast = "/push/list/last"
    static let pushListCome = "/push/list/come"
    static let pushListToday = "/push/list/today"
}
