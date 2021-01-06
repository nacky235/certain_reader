import Combine
import Foundation

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
    
    func fetch(_ searchText: String) {
        let searchArea = self.searchArea.value
        print("DEBUGG SearchText: \(searchText), searchArea: \(searchArea.rawValue)")
        var parameters: APILoginRequest {
            let params = searchArea.param
            return APILoginRequest(word: searchText, title: params.title, writer: params.writer, keyword: params.keywords, order: self.order.value, genre: self.genre.value, biggenre: self.biggenre.value)
        }
        parameters.dispatch { (novels) in
            self.novels.send(novels.novels)
        } onFailure: { (errorResponse, error) in
            print(error)
        }

    }
    
}
