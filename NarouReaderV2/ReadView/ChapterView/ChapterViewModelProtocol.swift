import Combine

public enum ChapterCommand {
    case showSnackbar(String)
}

protocol ChapterViewModelProtocol {
    var command: PassthroughSubject<ChapterCommand, Never> { get }
    var novelTitle: CurrentValueSubject<String, Never> { get }
    var chapters: CurrentValueSubject<NovelsContents,Never> { get }
    var ncode: String { get set }
    
    
    
    func fetch(_ ncode: String, completion: @escaping () -> Void)
}

