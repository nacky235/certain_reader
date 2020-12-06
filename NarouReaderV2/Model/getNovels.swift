//
//  getNovels.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/05.
//

import Foundation
import Kanna

let url = URL(string: "https://ncode.syosetu.com/n7798go/")!

func getChapters(chapterTitleElement: XMLElement) -> [String] {
    guard let next = chapterTitleElement.nextSibling, let linkElement = next.xpath("//dd/a").first, let title = linkElement.text else { return [] }
    // リンクはこうやってとる
    // let link = linkElement["href"]
    return [title] + getChapters(chapterTitleElement: next)
}

func loadChapters(url: URL) {
    
    let url = url
    do {
        let html = try String(contentsOf: url, encoding: .utf8)
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {

                let novelTitle = thing.xpath(#"//*[@class="novel_title"]"#).first?.text

                if let box = thing.xpath(#"//*[@class="index_box"]"#).first {
                    for chapter in box.xpath(#"//*[@class="chapter_title"]"#) {
                        let chapterTitle = chapter.content
                        let chapters = getChapters(chapterTitleElement: chapter)
                        print("ChapterTitle: ", chapterTitle ?? "")
                        print("Chapters", chapters)
                    }
                }

            }
        }
    } catch let error {
        print("Error: \(error)")
    }
}
