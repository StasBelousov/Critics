//
//  MovieCriticsAPIModel.swift
//  Critics
//
//  Created by Станислав Белоусов on 11/09/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import Foundation

struct MovieCritics: Codable {
    let status, copyright: String?
    let numResults: Int?
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

struct Result: Codable {
    let displayName: String?
    let sortName: String?
    let status: Status?
    let bio: String?
    let seoName: String?
    let multimedia: Multimedia?
    
    let displayTitle: String? // review
    let criticsPick: Int?
    let byline, headline, summaryShort, publicationDate: String?
    let openingDate: String?
    let dateUpdated: String?
    let link: Link?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case sortName = "sort_name"
        case status, bio
        case seoName = "seo_name"
        case multimedia
        
        case displayTitle = "display_title" //review
        case criticsPick = "critics_pick"
        case byline, headline
        case summaryShort = "summary_short"
        case publicationDate = "publication_date"
        case openingDate = "opening_date"
        case dateUpdated = "date_updated"
        case link
    }
}

struct Multimedia: Codable {
    let resource: Resource?
    let src: String? // review
    let width, height: Int? //review
}

struct Resource: Codable {
    let type: String
    let src: String
    let height, width: Int
    let credit: String
}

enum Status: String, Codable {
    case fullTime = "full-time"
    case partTime = "part-time"
}
// --- reviews---

// MARK: - Link
struct Link: Codable {
    let type: LinkType
    let url: String
    let suggestedLinkText: String

    enum CodingKeys: String, CodingKey {
        case type, url
        case suggestedLinkText = "suggested_link_text"
    }
}

enum LinkType: String, Codable {
    case article = "article"
}



