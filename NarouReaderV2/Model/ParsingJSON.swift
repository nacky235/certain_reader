//
//  ParsingJSON.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/17.
//

import Foundation


func parse(json: Data) -> Chapter {
    let decoder = JSONDecoder()
    var chapter: Chapter = Chapter()
    
    
    
    if let jsonChapter = try? decoder.decode(Chapter.self, from: json) {
        chapter = jsonChapter
    }
    
    return chapter
}
