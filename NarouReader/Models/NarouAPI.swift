//
//  NarouAPI.swift
//  NarouReader
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
    
    let title: Int //words in title
    let wname: Int // words in writer
    let keyword: Int //words in keyword
    
    let out: String = "json"
    let type: String = "re"
    let lim: Int = 30 // (1- 500)
    let order: String
    let genre: String
    let biggenre: String
    
    init(word: String, title: Int, writer: Int, keyword: Int, order: Order, genre: Genre, biggenre: BigGenre) {
        self.word = word
        self.title = title
        self.wname = writer
        self.keyword = keyword
        self.order = order.name
        self.genre = genre.stringGenre
        self.biggenre = biggenre.stringBigGenre
    }
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
    case all                = 0;
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
    
    var stringGenre: String {
        switch self {
        case .all:
            return "101-102-201-202-301-302-303-304-305-306-307-401-402-403-404-9901-9902-9903-9904-9999-9801"
        case .iseki_world:
            return "101"
        case .real_world:
            return "102"
        case .high_fantasy:
            return "201"
        case .low_fantasy:
            return "202"
        case .pure_literature:
            return "301"
        case .human_drama:
            return "302"
        case .history:
            return "303"
        case .suspense:
            return "304"
        case .horror:
            return "305"
        case .action:
            return "306"
        case .comedy:
            return "307"
        case .vr_game:
            return "401"
        case .space:
            return "402"
        case .science_fiction:
            return "403"
        case .panic:
            return "404"
        case .tale:
            return "9901"
        case .poetry:
            return "9902"
        case .essay:
            return "9903"
        case .replay:
            return "9904"
        case .other:
            return "9999"
        case .nongenre:
            return "9801"
        }
    }
    
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
        case .all:
            return "指定なし"
        }
    }

}

enum BigGenre: Int {
    case all = 0
    case love_romance = 1
    case fantasy = 2
    case litelature = 3
    case sf = 4
    case other = 99
    case nongenre = 98
    
    var stringBigGenre: String {
        switch self {
        case .all:
            return "1-2-3-4-99-98"
        case .love_romance:
            return "1"
        case .fantasy:
            return "2"
        case .litelature:
            return "3"
        case .sf:
            return "4"
        case .other:
            return "99"
        case .nongenre:
            return "98"
        }
    }
    
    var title: String {
        switch self {
        case .all:
            return "指定なし"
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

enum SearchArea: Int, CaseIterable {
    case all = 0
    case title = 1
    case writer = 2
    case keywords = 3
    
    var name: String {
        switch self {
        case .all:
            return "All"
        case .title:
            return "Title"
        case .writer:
            return "Writer"
        case .keywords:
            return "Keywords"
        }
    }
}

enum Order: String, CaseIterable {
    case new = "新着順"
    case favnovelcnt = "ブックマーク数の多い順"
    case reviewcnt = "レビュー数の多い順"
    case hyoka = "総合"
    case hyokaasc = "総合ポイントの低い順"
    case dailypoint = "日間"
    case weeklypoint = "週間ポイントの高い順"
    case monthlypoint = "月間ポイントの高い順"
    case quarterpoint = "四半期ポイントの高い順"
    case yearlypoint = "年間ポイントの高い順"
    case impressioncnt = "感想の多い順"
    case hyokacnt = "評価者数の多い順"
    case hyokacntasc = "評価者数の少ない順"
    case weekly = "週間"
    case lengthdesc = "小説本文の文字数が多い順"
    case lengthasc = "小説本文の文字数が少ない順"
    case ncodedesc = "新着投稿順"
    case old = "更新が古い順"
        
    var name: String {
        switch self {
        
        case .new:
            return "new"
        case .favnovelcnt:
            return "favnovelcnt"
        case .reviewcnt:
            return "reviewcnt"
        case .hyoka:
            return "hyoka"
        case .hyokaasc:
            return "hyokaasc"
        case .dailypoint:
            return "dailypoint"
        case .weeklypoint:
            return "weeklypoint"
        case .monthlypoint:
            return "monthlypoint"
        case .quarterpoint:
            return "quarterpoint"
        case .yearlypoint:
            return "yearlypoint"
        case .impressioncnt:
            return "impressioncnt"
        case .hyokacnt:
            return "hyokacnt"
        case .hyokacntasc:
            return "hyokacntasc"
        case .weekly:
            return "weekly"
        case .lengthdesc:
            return "lengthdesc"
        case .lengthasc:
            return "lengthasc"
        case .ncodedesc:
            return "ncodeasc"
        case .old:
            return "old"
        }
        
    }
}
