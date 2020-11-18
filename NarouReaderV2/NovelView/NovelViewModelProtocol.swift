import Combine

public enum NovelCommand {
    case showSnackbar(String)
}


protocol NovelViewModelProtocol {
    var command: PassthroughSubject<NovelCommand, Never> { get }
    var chapter: CurrentValueSubject<Chapter, Never> { get }
}
