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
    
    func getPhotoDetail(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        photoProvider.request(.getPhotoDetail(photoID: id)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Photo.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postPhoto(photoInfo: PhotoRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        photoProvider.request(.postPhoto(param: photoInfo)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Photo.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getPhotoTag(completion: @escaping (NetworkResult<Any>) -> Void) {
        photoProvider.request(.getPhotoTag) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, [Tag].self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func putPhoto(ids: [Int], completion: @escaping (NetworkResult<Any>) -> Void) {
        photoProvider.request(.putPhoto(ids: ids)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, Photo.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deletePhotoMenuTag(tagId: Int, photoIds: [Int], completion: @escaping (NetworkResult<Any>) -> Void) {
        photoProvider.request(.deletePhotoMenuTag(tagId: tagId, photoIds: photoIds)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, PhotoMenuTag.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
