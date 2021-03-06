//
//  TagResponse.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/20.
//

import Foundation

// MARK: - Tag
struct TagMainResponse: Codable {
    var recent: TagResponse
    var often: TagResponse
    var platform: TagResponse?
}

struct TagBookmarkResponse: Codable {
    let bookmarked: TagResponse
    let notBookmarked: TagResponse
}

struct TagResponse: Codable {
    let tags: [Tag]
}

struct Tag: Codable, Hashable {
    let uuid = UUID()
    var id: Int? = 0
    var name: String
    var bookmarkStatus: Bool? = nil
    var imageURL: String? = nil
    var tagType: TagType? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case bookmarkStatus = "bookmark_status"
        case imageURL = "image_url"
        case tagType = "tag_type"
    }
}

enum TagType: String, Codable {
    case general = "general"
    case platform = "platform"
}
