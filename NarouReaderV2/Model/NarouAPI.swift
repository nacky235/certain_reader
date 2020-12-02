//
//  NarouAPI.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/26.
//

import Foundation

struct Novel: Codable {
//    var chapters: [Chapter]
    var title: String
    var ncode: String
//    var userid: Int
    var writer: String
    var story: String
    var biggenre: Int
    var genre: Int
//    var gensaku: String
//    var keyword: String
//    var general_firstup: String
//    var general_lastup: String
//    var novel_type: Int
//    var end: Int
//    var general_all_no: Int
//    var length: Int
//    var time: Int
//    var isstop: Int
//    var isr15: Int
//    var isbl: Int
//    var isgl: Int
//    var iszankoku: Int
//    var istensei: Int
//    var istenni: Int
//    var pc_or_k: Int
//    var global_point: Int
//    var daily_point: Int
//    var weekly_point: Int
//    var monthly_point: Int
//    var quarter_point: Int
//    var yearly_point: Int
//    var fav_novel_cnt: Int
//    var impression_cnt: Int
//    var review_cnt: Int
//    var all_point: Int
//    var all_hyoka_cnt: Int
//    var sasie_cnt: Int
//    var kaiwaritu: Int
//    var novelupdated_at: String
//    var updated_at: String
}

struct AllCount: Codable {
    var allcount: Int
}

struct NarouContainer: Decodable {
    var allCount: AllCount
    var novels: [Novel]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        // Assume the first one is a Dog
        self.allCount = try container.decode(AllCount.self)

        // Assume the rest are Turtle
        var novels: [Novel] = []

        while !container.isAtEnd {
            let novel = try container.decode(Novel.self)
            novels.append(novel)
        }

        self.novels = novels
    }
}
