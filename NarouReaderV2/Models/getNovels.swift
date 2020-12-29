//
//  getNovels.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/05.
//

import Foundation
import Kanna

func getChapters(chapterTitleElement: XMLElement) -> [Chapter] {
    
    guard let title = chapterTitleElement.xpath("//dd/a").first?.text, let link = chapterTitleElement.xpath("//dd/a").first?["href"] else { return [] }
    
    let chapter: Chapter = Chapter(title: title, link: link)
    guard let next = chapterTitleElement.nextSibling else { return [chapter] }
    // リンクはこうやってとる
    // let link = linkElement["href"]
    return [chapter] + getChapters(chapterTitleElement: next)
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

func loadContent(urlString: String) -> [String] {
     //[]
    if let url = URL(string: urlString) {
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            if let doc = try? HTML(html: html, encoding: .utf8) {
                for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {
                    if let honbun = thing.xpath(#"//*[@id="novel_honbun"]"#).first, let firstLine = honbun.xpath("//p").first {
                        let content: [String] = getNovelsContent(currentElement: firstLine)
//                        print(content)
                        return content
                    }
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    return []
}

func getNovelsContent(currentElement: XMLElement) -> [String] {
    let line = currentElement.text ?? ""
    guard let next = currentElement.nextSibling else { return [line] }
    return [line] + getNovelsContent(currentElement: next)
}
