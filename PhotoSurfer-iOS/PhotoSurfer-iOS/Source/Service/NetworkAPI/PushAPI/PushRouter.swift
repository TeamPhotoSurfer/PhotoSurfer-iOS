//
//  PushAPI.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

enum PushRouter {
    case getPushListLast
    case getPushListCome
    case getPushListToday
}

extension PushRouter: BaseTargetType {
    var path: String {
        switch self {
        case .getPushListLast:
            return URLConstant.pushListLast
        case .getPushListCome:
            return URLConstant.pushListCome
        case .getPushListToday:
            return URLConstant.pushListToday
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPushListToday, .getPushListLast, .getPushListCome:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPushListToday, .getPushListLast, .getPushListCome:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPushListToday, .getPushListLast, .getPushListCome:
            return NetworkConstant.hasTokenHeader
        }
    }
}
