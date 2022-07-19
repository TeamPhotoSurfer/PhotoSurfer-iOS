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
}

extension TagRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getTagSearch:
            return URLConstant.tagSearch
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTagSearch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getTagSearch:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getTagSearch:
            return NetworkConstant.hasTokenHeader
        }
    }
}
