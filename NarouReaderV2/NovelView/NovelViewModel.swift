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
    var chapter: Chapter
    var url: String


    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency
   
//    init(dependency: Dependency, chapter: Chapter) {
//        self.chapter = CurrentValueSubject<Chapter, Never>(chapter)
//        self.dependency = dependency
//    }
    
    init(chapter: Chapter) {
        self.dependency = .default
        self.content = CurrentValueSubject<[String], Never>([])
        self.chapter = chapter
        self.url = "https://ncode.syosetu.com/" + chapter.link
    }
    

    deinit {
        if chapter.isRead {
            if var list = UserDefaults.standard.stringArray(forKey: "readList") {
                if list.filter({ $0 == chapter.link }) == [] {
                    list.append(chapter.link)
                }
                UserDefaults.standard.set(list, forKey: "readList")
            } else {
                UserDefaults.standard.setValue([chapter.link], forKey: "readList")
            }
        }
    }
    
//    func loadContent(urlString: String) -> [String] {
//        if let url = URL(string: urlString) {//[]
//            do {
//                let html = try String(contentsOf: url, encoding: .utf8)
//                if let doc = try? HTML(html: html, encoding: .utf8) {
//                    for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {
//
//                        let chapterTitle = thing.xpath(#"//*[@class="novel_subtitle"]"#).first?.text
//
//                        if let honbun = thing.xpath(#"//*[@id="novel_honbun"]"#).first {
//                            let content: [String] = getNovelsContent(nextElement: honbun.xpath("//p").first!)
//                            self.content.send(content)
//                            return content
//    //                        for line in honbun.xpath("//p") {
//    //
//    //                            let chapterTitle = chapter.content
//    //                            let chapters = getChapters(chapterTitleElement: chapter)
//    //
//    //                            print("ChapterTitle: ", chapterTitle ?? "")
//    //                            print("Chapters", novelsChapter.chapterName)
//    //                            self.chapters.send(novelsChapter)
//    //                        }
//                        }
//
//                    }
//                }
//            } catch let error {
//                print("Error: \(error)")
//            }
//        }
//        return []
//    }
    func loadContent(urlString: String) {
         //[]
        if let url = URL(string: urlString) {
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {
                        if let honbun = thing.xpath(#"//*[@id="novel_honbun"]"#).first, let firstLine = honbun.xpath("//p").first {
                            let content: [String] = getNovelsContent(currentElement: firstLine)
//                            print(content)
                            self.content.send(content)
                            return
                        }
                    }
                }
            } catch let error {
                print("Error: \(error)")
            }
        }
        return
    }
    
    func getNovelsContent(currentElement: XMLElement) -> [String] {
        let line = currentElement.text ?? ""

        guard let next = currentElement.nextSibling else { return [line] }
        // リンクはこうやってとる
    //     let link = linkElement["href"]
        return [line] + getNovelsContent(currentElement: next)
    }
}
