import Combine
import Foundation
import Kanna

final class NovelViewModel: NovelViewModelProtocol {
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<NovelCommand, Never>()
//    let chapter: CurrentValueSubject<Chapter, Never> = (Chapter())
    let content: CurrentValueSubject<[String], Never>

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency
   
//    init(dependency: Dependency, chapter: Chapter) {
//        self.chapter = CurrentValueSubject<Chapter, Never>(chapter)
//        self.dependency = dependency
//    }
    
    init(content: [String]) {
        self.dependency = .default
        self.content = CurrentValueSubject<[String], Never>(content)
    }
    
    func loadContent(ep: Int) -> [String] {
        let url = URL(string: "https://ncode.syosetu.com/n7798go/\(ep.description)")! //[]
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            if let doc = try? HTML(html: html, encoding: .utf8) {
                for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {
                    
                    let chapterTitle = thing.xpath(#"//*[@class="novel_subtitle"]"#).first?.text
                    
                    if let honbun = thing.xpath(#"//*[@id="novel_honbun"]"#).first {
                        let content: [String] = getNovelsContent(nextElement: honbun.xpath("//p").first!)
                        self.content.send(content)
                        return content
//                        for line in honbun.xpath("//p") {
//
//                            let chapterTitle = chapter.content
//                            let chapters = getChapters(chapterTitleElement: chapter)
//
//                            print("ChapterTitle: ", chapterTitle ?? "")
//                            print("Chapters", novelsChapter.chapterName)
//                            self.chapters.send(novelsChapter)
//                        }
                    }

                }
            }
        } catch let error {
            print("Error: \(error)")
        }
        return []
    }
    
    func getNovelsContent(nextElement: XMLElement) -> [String] {
        guard let next = nextElement.nextSibling, let linkElement = next.xpath("//p").first, let line = linkElement.text else { return [] }
        // リンクはこうやってとる
        // let link = linkElement["href"]
        return [line] + getChapters(chapterTitleElement: next)
    }
}
