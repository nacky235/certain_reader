import Combine
import Alamofire

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
    func fetch(_ searchText: String, searchArea: SearchArea)
}

extension SearchViewModelProtocol {
    func loadNovels(parameters:Parameters,completion: @escaping (([Novel]) -> Void)) {
        let decoder = JSONDecoder()
        AF.request("https://api.syosetu.com/novelapi/api/", method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
            
            switch response.result {
            case .success:
                do {
                    let novels = try decoder.decode(NarouContainer.self, from: Data(response.value!.utf8))
                    completion(novels.novels)
                } catch let error {
                    print("Error = \(error)")
                }
            case .failure:
                print("failure")
                
            }
        }
    }
}
