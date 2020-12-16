//
//  Chapter.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/15.
//

import Foundation

struct Chapter:  Equatable, Codable {
    var title: String
    var link: String
    init() {
        self.title = ""
        self.link = ""
    }
}

struct NovelsChapter: Equatable {
    var chapterTitle: [String]
    var chapters: [[Chapter]]
    init() {
        self.chapters = [[Chapter]]()
        self.chapterTitle = [String]()
    }
}
