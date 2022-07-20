//
//  PhotoRouter.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

enum PhotoRouter {
    case getPhotoSearch(ids: [Int])
}

extension PhotoRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getPhotoSearch(let ids):
            var idText = ""
            for id in ids {
                idText += "?id=\(id)&"
            }
            return "\(URLConstant.photoSearch)/\(idText)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPhotoSearch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPhotoSearch:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPhotoSearch:
            return NetworkConstant.hasTokenHeader
        }
    }
}
