//
//  PushResponse.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/20.
//

import Foundation

struct PushResponse: Codable {
    let push: [Push]
    let totalCount: Int
}

// MARK: - PushTodayResponse
struct PushTodayResponse: Codable {
    let today, tomorrow: Day
    let todayTomorrowCount, lastCount, comingCount: Int
}

// MARK: - Day
struct Day: Codable {
    let push: [Push]
}

// MARK: - Push
struct Push: Codable {
    let uuid = UUID()
    let id: Int? = nil
    let pushDate: String
    let imageURL: String? = nil
    let memo: String
    let photoID: Int? = nil
    let tags: [Tag]

    enum CodingKeys: String, CodingKey {
        case id, pushDate
        case imageURL = "imageUrl"
        case memo
        case photoID = "photoId"
        case tags
    }
}

struct PostPushResponse: Codable {
    let pushDate: String
    let memo: String
    let tags: [PostPushTagResponse]
}

struct PostPushTagResponse: Codable {
    let id: Int
}
