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
    var searchArea: SearchArea = .all
    var order = CurrentValueSubject<Order, Never>(.hyoka)
    var genre = CurrentValueSubject<Genre, Never>(.all)
    var biggenre = CurrentValueSubject<BigGenre, Never>(.all)
    

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func loadNovels(parameters: Parameters ,completion: @escaping (([Novel]) -> Void)) {
        
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
