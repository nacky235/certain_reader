import Combine

public enum SearchCommand {
    case showSnackbar(String)
}

public protocol SearchViewModelProtocol {
    var command: PassthroughSubject<SearchCommand, Never> { get }
}
