//
//  Parameters.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/08.
//

import Foundation

struct Parameters: Encodable {
    let word: String
    let notword: String
    
    let title: Int = 1 //words in title
    let ex: Int // words in ex
    let keyword: Int //words in keyword
    
    let out: String = "json"
    let type: String = "re"
    let lim: Int = 20 // (1- 500)
    let order: String
}


