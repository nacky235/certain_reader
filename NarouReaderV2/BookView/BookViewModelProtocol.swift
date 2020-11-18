import Combine

public enum BookCommand {
    case showSnackbar(String)
}

public protocol BookViewModelProtocol {
    var command: PassthroughSubject<BookCommand, Never> { get }
}
