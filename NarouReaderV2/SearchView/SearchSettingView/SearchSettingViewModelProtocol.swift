import Combine

public enum SearchSettingCommand {
    case showSnackbar(String)
}

public protocol SearchSettingViewModelProtocol {
    var command: PassthroughSubject<SearchSettingCommand, Never> { get }
}
