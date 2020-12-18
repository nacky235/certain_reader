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

struct Parameters: Encodable {
    let word: String
//    let notword: String
    
    let title: Int = 1 //words in title
    let ex: Int = 1 // words in ex
    let keyword: Int = 1 //words in keyword
    
    let out: String = "json"
    let type: String = "re"
    let lim: Int = 20 // (1- 500)
    let order: String = "hyoka"
}

struct AllCount: Codable {
    var allcount: Int
}

struct NarouContainer: Decodable {
    var allCount: AllCount
    var novels: [Novel]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.allCount = try container.decode(AllCount.self)
        var novels: [Novel] = []

        while !container.isAtEnd {
            let novel = try container.decode(Novel.self)
            novels.append(novel)
        }

        self.novels = novels
    }
}


enum Genre: Int {
    case iseki_world        = 101;
    case real_world         = 102;
    case high_fantasy       = 201;
    case low_fantasy        = 202;
    case pure_literature    = 301;
    case human_drama        = 302;
    case history            = 303;
    case suspense           = 304;
    case horror             = 305;
    case action             = 306;
    case comedy             = 307;
    case vr_game            = 401;
    case space              = 402;
    case science_fiction    = 403;
    case panic              = 404;
    case tale               = 9901;
    case poetry             = 9902;
    case essay              = 9903;
    case replay             = 9904;
    case other              = 9999;
    case nongenre           = 9801;
    
    var title: String {
        switch self {
        case .iseki_world:
            return "異世界"
        case .real_world:
            return "現実世界"
        case .high_fantasy:
            return "ハイファンタジー"
        case .low_fantasy:
            return "ローファンタジー"
        case .pure_literature:
            return "純文学"
        case .human_drama:
            return "ヒューマンドラマ"
        case .history:
            return "歴史"
        case .suspense:
            return "サスペンス"
        case .horror:
            return "ホラー"
        case .action:
            return "アクション"
        case .comedy:
            return "コメディー"
        case .vr_game:
            return "VRゲーム"
        case .space:
            return "宇宙"
        case .science_fiction:
            return "空想科学"
        case .panic:
            return "パニック"
        case .tale:
            return "童話"
        case .poetry:
            return "詩"
        case .essay:
            return "エッセイ"
        case .replay:
            return "リプレイ"
        case .other:
             return "その他"
        case .nongenre:
            return "ノンジャンル"
        
        }
    }

}

enum BigGenre: Int {
    case love_romance = 1
    case fantasy = 2
    case litelature = 3
    case sf = 4
    case other = 99
    case nongenre = 98
    
    var title: String {
        switch self {
        case .love_romance:
            return "恋愛"
        case .fantasy:
            return "ファンタジー"
        case .litelature:
            return "文芸"
        case .sf:
            return "SF"
        case .other:
            return "その他"
        case .nongenre:
            return "ノンジャンル"
        
        }
    }
    
}
