import Combine

public enum HNovelsDetailCommand {
    case showSnackbar(String)
}


protocol HNovelsDetailViewModelProtocol {
    var command: PassthroughSubject<HNovelsDetailCommand, Never> { get }
    var hNovel: HNovel { get }
    
}
