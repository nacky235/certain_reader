import Combine

public enum ReaderCommand {
    case showSnackbar(String)
}

public protocol ReaderViewModelProtocol {
    var command: PassthroughSubject<ReaderCommand, Never> { get }
}
