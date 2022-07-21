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
    case putPhoto(ids: [Int])
    case deletePhotoMenuTag(tagId: Int, photoIds: [Int])
    case postAddPhotoMenuTag(photoId: [Int], name: String, type: TagType)
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
        case .putPhoto:
            return URLConstant.photo
        case .deletePhotoMenuTag(let tagId, _):
            return "\(URLConstant.photoMenuTag)/\(tagId)"
        case .postAddPhotoMenuTag:
            return URLConstant.photoMenuTag
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPhotoSearch, .getPhotoDetail, .getPhotoTag:
            return .get
        case .postPhoto, .postAddPhotoMenuTag:
            return .post
        case .putPhoto:
            return .put
        case .deletePhotoMenuTag:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getPhotoSearch(let ids):
            return .requestParameters(parameters: ["id": ids], encoding: URLEncoding.default)
        case .getPhotoDetail, .getPhotoTag:
            return .requestPlain
        case .postPhoto(let param):
            return .uploadMultipart(makeMultiPartData(parameter: param, image: param.file))
        case .deletePhotoMenuTag(_, let photoIds):
            return .requestParameters(parameters: ["photoIds": photoIds],
                                      encoding: JSONEncoding.default)
        case .putPhoto(let ids):
            return .requestParameters(parameters: ["id": ids], encoding: URLEncoding.queryString)
        case .postAddPhotoMenuTag(let photoId, let name, let type):
            return .requestParameters(parameters: ["photoId": photoId,
                                                   "name": name,
                                                   "type": type.rawValue],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPhotoSearch, .getPhotoDetail, .getPhotoTag, .putPhoto, .deletePhotoMenuTag, .postAddPhotoMenuTag:
            return NetworkConstant.hasTokenHeader
        case .postPhoto:
            return NetworkConstant.hasMultipartHeader
        }
    }
}

extension PhotoRouter {
    func makeMultiPartData(parameter: PhotoRequest, image: UIImage?) -> [Moya.MultipartFormData] {
        var multiPartData: [Moya.MultipartFormData] = []
        if let imageData = image {
            let imageFile = MultipartFormData(provider: .data(imageData.jpegData(compressionQuality: 1) ?? Data()),
                                              name: "file",
                                              fileName: "surfer.jpg",
                                              mimeType: "image/jpeg")
            multiPartData.append(imageFile)
        }
        for i in 0..<parameter.tags.count {
            let name = parameter.tags[i].name.data(using: .utf8) ?? Data()
            let type = parameter.tags[i].tagType?.rawValue.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(name), name: "tags[\(i)][name]"))
            multiPartData.append(MultipartFormData(provider: .data(type), name: "tags[\(i)][type]"))
        }
        
        return multiPartData
    }
}
