import Combine

public enum HNovelsContentsCommand {
    case showSnackbar(String)
}

public protocol HNovelsContentsViewModelProtocol {
    var command: PassthroughSubject<HNovelsContentsCommand, Never> { get }
}
