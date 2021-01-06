//
//  getNovels.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2020/12/05.
//

import Foundation
import Kanna

func getChapters(chapterTitleElement: XMLElement) -> [Chapter] {
    
    guard let title = chapterTitleElement.xpath("//dd/a").first?.text, let link = chapterTitleElement.xpath("//dd/a").first?["href"] else { return [] }
    
    let chapter: Chapter = Chapter(title: title, link: link)
    guard let next = chapterTitleElement.nextSibling else { return [chapter] }
    
    return [chapter] + getChapters(chapterTitleElement: next)
}


func getNovelsContent(currentElement: XMLElement) -> [String] {
    let line = currentElement.text ?? ""
    guard let next = currentElement.nextSibling else { return [line] }
    return [line] + getNovelsContent(currentElement: next)
}


