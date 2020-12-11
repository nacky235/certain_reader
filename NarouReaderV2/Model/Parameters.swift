//
//  Parameters.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/08.
//

import Foundation

struct Parameters: Encodable {
    let title: Int = 1 //words in title
    let word: String
    let genre: Int
    let out: String = "json"
}
