//
//  Book.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/19.
//

import Foundation

struct Book: Identifiable, Equatable, Codable {
    var id: String
    var title: String
    var author: String
    var genre: String
    var subgenre: String
    
    init() {
        self.id = "0"
        self.title = "default"
        self.author = "default"
        self.genre = "default"
        self.subgenre = "default"
    }
}
