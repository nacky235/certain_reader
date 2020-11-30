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

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func loadNovels(completion: @escaping (([Novel]) -> Void)) {
        
        let url = URL(string: "https://api.syosetu.com/novelapi/api/?out=json")!
        let urlRequest = URLRequest(url: url)
        let novels: [Novel] = []

        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            data, urlResponse, error in

            print("aaa")

            do {
                let novelContainer = try JSONDecoder().decode(NarouContainer.self, from: data!)
                print(novels)
                completion(novelContainer.novels)
            } catch let error {
                print("Error = \(error)")
            }
        }
        
        
        task.resume()
        
    }
    
    func fetch() {
        loadNovels { (novel) in
            self.novels.send(novel)
        }
    }
}
