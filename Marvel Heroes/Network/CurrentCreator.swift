//
//  CurrentCreator.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 19.03.2021.
//

import Foundation

// MARK: - Root
struct CurrentCreator: Codable {
    let data: DataCreator
}

// MARK: - DataClass
struct DataCreator: Codable {
    let offset, limit, total, count: Int
    let results: [ResultCreator]
}

// MARK: - Result
struct ResultCreator: Codable {
    let id: Int
    let firstName, middleName, lastName: String
    let fullName: String
    let thumbnail: CreatorPicture
    let comics: CreatorComics
    let urls: [URLElement2]
}

// MARK: - Comics
struct CreatorComics: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorItem]
    let returned: Int
}

// MARK: - ComicsItem
struct CreatorItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Thumbnail
struct CreatorPicture: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement2: Codable {
    let type: String
    let url: String
}
