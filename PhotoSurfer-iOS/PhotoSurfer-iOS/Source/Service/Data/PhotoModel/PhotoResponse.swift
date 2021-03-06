//
//  PhotoResponse.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/20.
//

import Foundation

struct PhotoSearchResponse: Codable {
    let tags: [Tag]
    let photos: [Photo]
}

// MARK: - Photo
struct Photo: Codable, Hashable {
    let id: Int
    let imageURL: String
    let tags: [Tag]?
    let push: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageUrl"
        case tags
        case push
    }
}

struct PhotoMenuTag: Codable, Hashable {
    let countDeletedPhoto: Int
}

struct postAddPhotoMenuTagResponse: Codable, Hashable {
    let tagId: Int
    let name: String
}
