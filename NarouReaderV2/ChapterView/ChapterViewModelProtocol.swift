import Combine

public enum ChapterCommand {
    case showSnackbar(String)
}

protocol ChapterViewModelProtocol {
    var command: PassthroughSubject<ChapterCommand, Never> { get }
    var book: CurrentValueSubject<Book, Never> { get }
    var chapters: CurrentValueSubject<[Chapter], Never> { get }
    
    
    func fetch()
}

