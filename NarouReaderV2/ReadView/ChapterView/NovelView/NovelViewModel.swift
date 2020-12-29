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
    let content: CurrentValueSubject<[String], Never>
    var chapter: CurrentValueSubject<Chapter, Never>
    var url: String


    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency
    
    init(chapter: Chapter) {
        self.dependency = .default
        self.content = CurrentValueSubject<[String], Never>([])
        self.chapter = CurrentValueSubject<Chapter, Never>(chapter)
        self.url = "https://ncode.syosetu.com/" + chapter.link
        loadContent(urlString: url)
    }
    

    deinit {
        if chapter.value.isRead {
            if var list = UserDefaults.standard.stringArray(forKey: "readList") {
                if list.filter({ $0 == chapter.value.link }) == [] {
                    list.append(chapter.value.link)
                }
                UserDefaults.standard.set(list, forKey: "readList")
            } else {
                UserDefaults.standard.setValue([chapter.value.link], forKey: "readList")
            }
        }
    }

    func loadContent(urlString: String) {
         //[]
        if let url = URL(string: urlString) {
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    for thing in doc.xpath(#"//*[@id="novel_contents"]"#) {
                        if let title = thing.xpath(#"//*[@class="novel_subtitle"]"#).first?.text {
                            var chapter = self.chapter.value
                            chapter.title = title
                            self.chapter.send(chapter)
                        }
                        if let honbun = thing.xpath(#"//*[@id="novel_honbun"]"#).first, let firstLine = honbun.xpath("//p").first {
                            let content: [String] = getNovelsContent(currentElement: firstLine)
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
