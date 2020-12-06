import Combine

public enum ChapterCommand {
    case showSnackbar(String)
}

protocol ChapterViewModelProtocol {
    var command: PassthroughSubject<ChapterCommand, Never> { get }
    var novelTitle: CurrentValueSubject<String, Never> { get }
    var chapters: CurrentValueSubject<NovelsChapter,Never> { get }
    
    
    
    func fetch(_ ncode: String)
}

