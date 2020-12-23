//
//  NarouR18API.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/21.
//

import Foundation

struct HNovel: Codable {
    var title: String
    var ncode: String
    var writer: String
    var story: String
    var nocgenre: Int
}

struct HParameter: Encodable {
    var word: String
    var keyword: String
    var nocgenre: String = "1-4"
    var order: String = "hyoka"
    
    var out: String = "json"
}

struct HAllCount: Codable {
    var allcount: Int
}

struct HNarouContainer: Decodable {
    var allCount: HAllCount
    var novels: [HNovel]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.allCount = try container.decode(HAllCount.self)
        var novels: [HNovel] = []

        while !container.isAtEnd {
            let novel = try container.decode(HNovel.self)
            novels.append(novel)
        }

        self.novels = novels
    }
}
