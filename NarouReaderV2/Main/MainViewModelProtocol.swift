import Combine

public enum MainCommand {
    case showSnackbar(String)
}

public protocol MainViewModelProtocol {
    var command: PassthroughSubject<MainCommand, Never> { get }
}
