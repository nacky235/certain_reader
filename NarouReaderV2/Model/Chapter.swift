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
    var isRead: Bool
    init() {
        self.title = ""
        self.link = ""
        self.isRead = false
    }
    init(link: String) {
        self.title = ""
        self.link = link
        self.isRead = false
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
