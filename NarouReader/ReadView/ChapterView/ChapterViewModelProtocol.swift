import Combine
import Foundation
import Kanna

public enum ChapterCommand {
    case showSnackbar(String)
}

protocol ChapterViewModelProtocol {
    var command: PassthroughSubject<ChapterCommand, Never> { get }
    var novelTitle: CurrentValueSubject<String, Never> { get }
    var chapters: CurrentValueSubject<NovelsContents,Never> { get }
    var ncode: String { get set }
    
    
    
    func fetch(_ ncode: String, completion: @escaping () -> Void)
}

extension ChapterViewModelProtocol {
    func fetch(_ ncode: String, completion: @escaping () -> Void) {
        
        let url = URL(string: "https://ncode.syosetu.com/\(ncode)/")!
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            if let doc = try? HTML(html: html, encoding: .utf8) {
                for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {

                    let novelTitle = thing.xpath(#"//*[@class="novel_title"]"#).first?.text
                    self.novelTitle.send(novelTitle!)
                    if let box = thing.xpath(#"//*[@class="index_box"]"#).first {
                        var novelsChapter: NovelsContents = NovelsContents()
                        
                        if box.xpath(#"//*[@class="chapter_title"]"#).first != nil {
                            for chapter in box.xpath(#"//*[@class="chapter_title"]"#) {
                                let chapterTitle = chapter.content
                                novelsChapter.chapterTitle.append(chapterTitle!)
                                let chapters = getChapters(chapterTitleElement: chapter.nextSibling!)
                                novelsChapter.chapters.append(chapters)
                                self.chapters.send(novelsChapter)
                                completion()
                            }
                        } else {
                            let firstChapter = box.xpath("//dl").first
                            novelsChapter.chapterTitle.append("")
                            let chapters = getChapters(chapterTitleElement: firstChapter!)
                            novelsChapter.chapters.append(chapters)
                            self.chapters.send(novelsChapter)
                            completion()
                        }
                        
                    }

                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
}
