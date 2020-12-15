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
    let out: String = "json"
    let type: String = "re"
}
