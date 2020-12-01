import Combine

public enum NovelsDetailCommand {
    case showSnackbar(String)
}

protocol NovelsDetailViewModelProtocol {
    var command: PassthroughSubject<NovelsDetailCommand, Never> { get }
    var novel: Novel { get }
}
