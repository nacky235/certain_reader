import Combine

public enum SearchCommand {
    case showSnackbar(String)
}

protocol SearchViewModelProtocol {
    var command: PassthroughSubject<SearchCommand, Never> { get }
    var novels: CurrentValueSubject<[Novel], Never> { get }
    var searchArea: SearchArea { get set }
    var order: CurrentValueSubject<Order, Never> { get }
    var genre: CurrentValueSubject<Genre, Never> { get }
    var biggenre: CurrentValueSubject<BigGenre, Never> { get }
    
    func loadNovels(parameters:Parameters,completion: @escaping (([Novel]) -> Void))
    
}
