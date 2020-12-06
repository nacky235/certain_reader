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
    var chapters = CurrentValueSubject<NovelsChapter, Never>(NovelsChapter())

    private let cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, ncode: String) {
        self.dependency = dependency
        self.fetch(ncode)
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
                        var novelsChapter: NovelsChapter = NovelsChapter()
                        for (index, chapter) in box.xpath(#"//*[@class="chapter_title"]"#).enumerated() {
                            let chapterTitle = chapter.content
                            novelsChapter.chapterTitle.append(chapterTitle!)
                            let chapters = getChapters(chapterTitleElement: chapter)
                            novelsChapter.chapterName.append(chapters)
                            print("ChapterTitle: ", chapterTitle ?? "")
                            print("Chapters", novelsChapter.chapterName)
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

