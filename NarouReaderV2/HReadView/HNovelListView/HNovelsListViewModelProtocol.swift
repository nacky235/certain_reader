import Combine

public enum HNovelsListCommand {
    case showSnackbar(String)
}

protocol HNovelsListViewModelProtocol {
    var command: PassthroughSubject<HNovelsListCommand, Never> { get }
    var novels: CurrentValueSubject<[HNovel], Never> { get }
    
    func load(completion: @escaping () -> Void)
}
