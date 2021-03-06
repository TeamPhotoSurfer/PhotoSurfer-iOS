//
//  PushAPI.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/19.
//

import Foundation

import Moya

enum PushRouter {
    case getPush(id: Int)
    case getPushListLast
    case getPushListCome
    case getPushListToday
    case postPush(photoID: Int, param: PushAlarmRequest)
}

extension PushRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getPush(let id):
            return "\(URLConstant.push)/\(id)"
        case .getPushListLast:
            return URLConstant.pushListLast
        case .getPushListCome:
            return URLConstant.pushListCome
        case .getPushListToday:
            return URLConstant.pushListToday
        case .postPush(let photoID, _):
            return "\(URLConstant.push)/\(photoID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPush, .getPushListToday, .getPushListLast, .getPushListCome:
            return .get
        case .postPush:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPush, .getPushListToday, .getPushListLast, .getPushListCome:
            return .requestPlain
        case .postPush(_, let param):
            return .requestParameters(parameters: ["memo": param.memo,
                                                   "pushDate": param.pushDate,
                                                   "tagIds": param.tagIDs],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPush, .getPushListToday, .getPushListLast, .getPushListCome:
            return NetworkConstant.hasTokenHeader
        case .postPush:
            return NetworkConstant.hasTokenHeader
        }
    }
}
