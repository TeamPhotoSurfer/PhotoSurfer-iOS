//
//  PushService.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

public class PushService {
    static let shared = PushService()
    var pushProvider = MoyaProvider<PushRouter>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func getPush(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        pushProvider.request(.getPush(id: id)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Push.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getPushListLast(completion: @escaping (NetworkResult<Any>) -> Void) {
        pushProvider.request(.getPushListLast) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, PushResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getPushListComing(completion: @escaping (NetworkResult<Any>) -> Void) {
        pushProvider.request(.getPushListCome) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, PushResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getPushListToday(completion: @escaping (NetworkResult<Any>) -> Void) {
        pushProvider.request(.getPushListToday) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, PushTodayResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postPush(photoID: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        pushProvider.request(.postPush(photoID: photoID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Push.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
