import Combine

public enum ChapterCommand {
    case showSnackbar(String)
}



protocol ChapterViewModelProtocol {
    var command: PassthroughSubject<ChapterCommand, Never> { get }
    var chapters: CurrentValueSubject<[Chapter], Never> { get }
    
    func fetch()
    func show(chapter: [Chapter])
    
//    func transition(chapter: chapters.value)
}

