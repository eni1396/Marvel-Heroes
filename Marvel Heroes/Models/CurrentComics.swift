//
//  CurrentComics.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 06.03.2021.
//

import Foundation

///Модель для  комиксов
struct CurrentComics: Codable {
    let data: DataComics
}

// MARK: - DataClass
struct DataComics: Codable {
    let offset, limit, total, count: Int
    let results: [ResultComics]
}

// MARK: - Result
struct ResultComics: Codable {
    let title: String
    let description: String?
    let urls: [URLs]
    let thumbnail: ThumbnailComics
    let creators, characters, stories, events: Characters
}

struct URLs: Codable {
    let type: String
    let url: String
}
// MARK: - Characters
struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
    let returned: Int
}

// MARK: - Item
struct Item: Codable {
    let resourceURI: String
    let name: String
    //let type: String
}

// MARK: - Thumbnail
struct ThumbnailComics: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
