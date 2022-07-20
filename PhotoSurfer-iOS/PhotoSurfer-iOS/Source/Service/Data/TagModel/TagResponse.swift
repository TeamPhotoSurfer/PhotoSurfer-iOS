//
//  TagResponse.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation

// MARK: - Tag
struct TagMainResponse: Codable {
    var recent: TagResponse
    var often: TagResponse
    var platform: TagResponse?
}

struct TagResponse: Codable {
    let tags: [Tag]
}

struct Tag: Codable, Hashable {
    let uuid = UUID()
    var id: Int? = 0
    let name: String
}
