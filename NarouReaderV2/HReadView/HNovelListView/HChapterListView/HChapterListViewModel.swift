import Combine
import Foundation
import Kanna

final class HChapterListViewModel: HChapterListViewModelProtocol {
    
    
    
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<HChapterListCommand, Never>()
    var chapters: NovelsContents = NovelsContents()
    var ncode: String

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, novel: HNovel) {
        self.dependency = dependency
        self.ncode = novel.ncode
        load()
    }
    
    func load() {
        let ncode = self.ncode
        if var url = URL(string: "https://novel18.syosetu.com/") {
            url.appendPathComponent(ncode)
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {

                        let novelTitle = thing.xpath(#"//*[@class="novel_title"]"#).first?.text
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
                                    self.chapters = novelsChapter
                                }
                            } else {
                                let firstChapter = box.xpath("//dl").first
                                novelsChapter.chapterTitle.append("")
                                let chapters = getChapters(chapterTitleElement: firstChapter!)
                                novelsChapter.chapters.append(chapters)
                                self.chapters = novelsChapter
                            }
                            
                        }

                    }
                }
            } catch let error {
                print(error)
            }
            
        }
    }
}
