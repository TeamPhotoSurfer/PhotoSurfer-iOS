//
//  AuthService.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

public class AuthService {
    static let shared = AuthService()
    var authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func postAuthLogin(authRequest: AuthRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        authProvider.request(.postAuthLogin(param: authRequest)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, AuthResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
