import Combine
import Foundation
import Alamofire

final class HSearchViewModel: HSearchViewModelProtocol {
    
    
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<HSearchCommand, Never>()
    var HNovels = CurrentValueSubject<[HNovel], Never>([])
    var parameters = CurrentValueSubject<HParameter, Never>(HParameter(word: "", keyword: ""))
    

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func loadHNovels(completion: @escaping () -> Void) {
        
        let decoder = JSONDecoder()

        AF.request("https://api.syosetu.com/novel18api/api/", method: .get, parameters: parameters.value, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
            
            switch response.result {
            case .success:
                do {
                    let novels = try decoder.decode(HNarouContainer.self, from: Data(response.value!.utf8))
                    self.HNovels.send(novels.novels)
                    completion()
                    
                } catch let error {
                    print("Error = \(error)")
                }
            case .failure:
                print("failure")
                
            }
        }
    }
}
