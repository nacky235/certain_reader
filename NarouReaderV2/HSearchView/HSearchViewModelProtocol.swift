import Combine

public enum HSearchCommand {
    case showSnackbar(String)
}

protocol HSearchViewModelProtocol {
    var command: PassthroughSubject<HSearchCommand, Never> { get }
    var HNovels: CurrentValueSubject<[HNovel], Never> { get }
    var parameters: CurrentValueSubject<HParameter, Never> { get }
    
    func loadHNovels(completion: @escaping (() -> Void))
}
