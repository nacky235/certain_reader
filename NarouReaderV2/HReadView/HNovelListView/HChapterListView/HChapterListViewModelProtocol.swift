import Combine

public enum HChapterListCommand {
    case showSnackbar(String)
}

protocol HChapterListViewModelProtocol {
    var command: PassthroughSubject<HChapterListCommand, Never> { get }
    var chapters: NovelsContents { get }
    var ncode: String { get }
    
    func load() 
}
