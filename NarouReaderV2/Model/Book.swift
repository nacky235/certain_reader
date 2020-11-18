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
    var genere: String
    var subgenre: String
}
