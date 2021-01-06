import Combine

public enum SettingCommand {
    case showSnackbar(String)
}

public protocol SettingViewModelProtocol {
    var command: PassthroughSubject<SettingCommand, Never> { get }
}
