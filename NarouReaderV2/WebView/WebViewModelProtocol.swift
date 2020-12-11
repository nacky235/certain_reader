import Combine

public enum WebCommand {
    case showSnackbar(String)
}

public protocol WebViewModelProtocol {
    var command: PassthroughSubject<WebCommand, Never> { get }
}
