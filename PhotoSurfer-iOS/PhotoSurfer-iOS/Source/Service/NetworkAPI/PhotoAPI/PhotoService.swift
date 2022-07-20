//
//  PhotoService.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

public class PhotoService {
    static let shared = PhotoService()
    var photoProvider = MoyaProvider<PhotoRouter>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func getPhotoSearch(ids: [Int], completion: @escaping (NetworkResult<Any>) -> Void) {
        photoProvider.request(.getPhotoSearch(ids: ids)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, PhotoSearchResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
