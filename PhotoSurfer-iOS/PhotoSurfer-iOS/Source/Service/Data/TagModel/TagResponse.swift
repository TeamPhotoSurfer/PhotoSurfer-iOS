//
//  TagResponse.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation


struct TagResponse: Codable {
    let tags: [Tag]
}

// MARK: - Tag
struct TagMain: Codable, Hashable {
    var recent: [Tag]
    var often: [Tag]
    var platform: [Tag]
}

struct Tag: Codable, Hashable {
    let uuid = UUID()
    var id: Int? = 0
    let name: String
}
