//
//  TagRouter.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

enum TagRouter {
    case getTagSearch
    case getTagMain
    case getTag
    case getTagBookmark
}

extension TagRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getTagSearch:
            return URLConstant.tagSearch
        case .getTagMain:
            return URLConstant.tagMain
        case .getTag:
            return URLConstant.tag
        case .getTagBookmark:
            return URLConstant.tagBookmark
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTagSearch:
            return .get
        case .getTagMain:
            return .get
        case .getTag:
            return .get
        case .getTagBookmark:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getTagSearch:
            return .requestPlain
        case .getTagMain:
            return .requestPlain
        case .getTag:
            return .requestPlain
        case .getTagBookmark:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getTagSearch:
            return NetworkConstant.hasTokenHeader
        case .getTagMain:
            return NetworkConstant.hasTokenHeader
        case .getTag:
            return NetworkConstant.hasTokenHeader
        case .getTagBookmark:
            return NetworkConstant.hasTokenHeader
        }
    }
}
