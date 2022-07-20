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
    case getPhotoDetail(photoID: Int)
    case postPhoto(param: PhotoRequest)
    case getPhotoTag
}

extension PhotoRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getPhotoSearch(_):
            return "\(URLConstant.photoSearch)/"
        case .getPhotoDetail(let id):
            return "\(URLConstant.photoDetail)/\(id)"
        case .postPhoto:
            return "\(URLConstant.photo)/"
        case .getPhotoTag:
            return URLConstant.photoTag
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPhotoSearch, .getPhotoDetail, .getPhotoTag:
            return .get
        case .postPhoto:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPhotoSearch(let ids):
            return .requestParameters(parameters: ["id": ids], encoding: URLEncoding.default)
        case .getPhotoDetail, .getPhotoTag:
            return .requestPlain
        case .postPhoto:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPhotoSearch, .getPhotoDetail, .getPhotoTag:
            return NetworkConstant.hasTokenHeader
        case .postPhoto:
            return NetworkConstant.hasTokenHeader
        }
    }
}
