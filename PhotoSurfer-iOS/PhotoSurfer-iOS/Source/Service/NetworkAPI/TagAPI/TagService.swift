//
//  TagService.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/19.
//

import Foundation

import Moya

public class TagService {
    static let shared = TagService()
    var tagProvider = MoyaProvider<TagRouter>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func getTagSearch(completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.getTagSearch) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, TagResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getTagMain(completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.getTagMain) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, TagMainResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getTag(completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.getTag) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, TagBookmarkResponse.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func putTagBookmark(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.putTagBookmark(tagId: id)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Tag.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func delTagBookmark(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.delTagBookmark(tagId: id)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Tag.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
