import Combine
import Foundation
import Alamofire

final class HNovelsListViewModel: HNovelsListViewModelProtocol {
    var novels = CurrentValueSubject<[HNovel], Never>([])
    
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<HNovelsListCommand, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func load(completion: @escaping () -> Void) {
        if UserDefaults.standard.stringArray(forKey: "Hnovels") != [] {
            let novelList = UserDefaults.standard.stringArray(forKey: "Hnovels")?.joined(separator: "-")
            let decoder = JSONDecoder()
            let parameter = ["ncode": novelList,"out":"json"]
            
            AF.request("https://api.syosetu.com/novel18api/api/", method: .get, parameters: parameter, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
                
                switch response.result {
                case .success:
                    
                    do {
                        let narouContainer = try decoder.decode(HNarouContainer.self, from: Data(response.value!.utf8))
                        var novels: [HNovel] = []
                        let list = UserDefaults.standard.stringArray(forKey: "Hnovels")!
                        for novel in list {
                            novels.append(contentsOf: narouContainer.novels.filter{ $0.ncode == novel })
                        }
                        self.novels.send(novels)
                    } catch let error {
                        print("Error = \(error)")
                    }
                case .failure:
                    print("failure")
                }
            }
        }
        completion()
    }
}
