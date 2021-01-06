import Combine
import Foundation

public enum SearchCommand {
    case showSnackbar(String)
}

protocol SearchViewModelProtocol {
    var command: PassthroughSubject<SearchCommand, Never> { get }
    var novels: CurrentValueSubject<[Novel], Never> { get }
    var searchArea: CurrentValueSubject<SearchArea, Never> { get }
    var order: CurrentValueSubject<Order, Never> { get }
    var genre: CurrentValueSubject<Genre, Never> { get }
    var biggenre: CurrentValueSubject<BigGenre, Never> { get }
    
    func pushData(selected: (biggenre: BigGenre, genre: Genre, order: Order))
    func fetch(_ searchText: String)
}
