//
//  Chapter.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/15.
//

import Foundation

struct Chapter:  Identifiable, Equatable, Codable {
    var bookId: Int
    var id: String
    var title: String
    var episodeNumber: Int
    var content: String
    
}

