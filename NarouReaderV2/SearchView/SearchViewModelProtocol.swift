import Combine

public enum SearchCommand {
    case showSnackbar(String)
}

protocol SearchViewModelProtocol {
    var command: PassthroughSubject<SearchCommand, Never> { get }
    var novels: CurrentValueSubject<[Novel], Never> { get }
    var searchArea: SearchArea { get set }
    
    func loadNovels(parameters:Parameters,completion: @escaping (([Novel]) -> Void))
    
}
