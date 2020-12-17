import Combine
import UIKit
import Kanna

final class ChapterViewModel: ChapterViewModelProtocol {
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<ChapterCommand, Never>()
    var novelTitle = CurrentValueSubject<String, Never>("")
    var chapters = CurrentValueSubject<NovelsContents, Never>(NovelsContents())
    var ncode = ""

    private let cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, ncode: String) {
        self.dependency = dependency
        self.ncode = ncode
    }

    func fetch(_ ncode: String) {
        
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
//                                print("ChapterTitle: ", chapterTitle ?? "")
//                                print("Chapters", novelsChapter.chapterName)
                                self.chapters.send(novelsChapter)
                            }
                        } else {
                            let firstChapter = box.xpath("//dl").first
                            novelsChapter.chapterTitle.append("")
                            let chapters = getChapters(chapterTitleElement: firstChapter!)
                            novelsChapter.chapters.append(chapters)
                            self.chapters.send(novelsChapter)
                        }
                        
                    }

                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
}

