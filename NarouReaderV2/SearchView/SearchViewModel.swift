import Combine
import Foundation
import Alamofire

final class SearchViewModel: SearchViewModelProtocol {
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<SearchCommand, Never>()
    let novels = CurrentValueSubject<[Novel], Never>([])
    var searchArea = CurrentValueSubject<SearchArea, Never>(.all)
    var order = CurrentValueSubject<Order, Never>(.hyoka)
    var genre = CurrentValueSubject<Genre, Never>(.all)
    var biggenre = CurrentValueSubject<BigGenre, Never>(.all)
    

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func pushData(selected: (biggenre: BigGenre, genre: Genre, order: Order)) {
        self.biggenre.send(selected.biggenre)
        self.genre.send(selected.genre)
        self.order.send(selected.order)
    }
    
    func fetch(_ searchText: String, searchArea: SearchArea) {
        var parameters: Parameters {
            switch searchArea {
            case .all:
                return Parameters(word: searchText, title: 1, writer: 1, keyword: 1, order: self.order.value, genre: self.genre.value, biggenre: self.biggenre.value)
            case .title:
                return Parameters(word: searchText, title: 1, writer: 0, keyword: 0, order: self.order.value, genre: self.genre.value, biggenre: self.biggenre.value)
            case .writer:
                return Parameters(word: searchText, title: 0, writer: 1, keyword: 0, order: self.order.value, genre: self.genre.value, biggenre: self.biggenre.value)
            case .keywords:
                return Parameters(word: searchText, title: 0, writer: 0, keyword: 1, order: self.order.value, genre: self.genre.value, biggenre: self.biggenre.value)
            }
        }
        loadNovels(parameters: parameters) { (novel) in
            self.novels.send(novel)
        }
    }
    
}
