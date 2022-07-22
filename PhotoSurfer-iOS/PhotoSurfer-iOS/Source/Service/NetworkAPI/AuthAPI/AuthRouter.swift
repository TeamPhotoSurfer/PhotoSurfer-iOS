//
//  AuthRouter.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

enum AuthRouter {
    case postAuthLogin(param: AuthRequest)
}

extension AuthRouter: BaseTargetType {
    var path: String {
        switch self {
        case .postAuthLogin(_):
            return URLConstant.authLogin
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postAuthLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postAuthLogin(let param):
            return .requestParameters(parameters: ["param": AuthResponse], encoding: JSONEncoding.default)
        }
    }
}
