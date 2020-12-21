import Combine
import Foundation
import Alamofire

final class BookViewModel: BookViewModelProtocol {
    
    
    struct Dependency {
        static var `default`: Dependency {
            Dependency(
            )
        }
    }

    // [Output]

    let command = PassthroughSubject<BookCommand, Never>()
    let novels = CurrentValueSubject<[Novel], Never>([])

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    func loadNovels(completion: @escaping () -> Void) {
        if UserDefaults.standard.stringArray(forKey: "novels") != [] {
            let novelList = UserDefaults.standard.stringArray(forKey: "novels")?.joined(separator: "-")
            let decoder = JSONDecoder()
            let parameter = ["ncode": novelList,"out":"json"]
            
            AF.request("https://api.syosetu.com/novelapi/api/", method: .get, parameters: parameter, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
                
                switch response.result {
                case .success:
                    
                    do {
                        let narouContainer = try decoder.decode(NarouContainer.self, from: Data(response.value!.utf8))
                        var novels: [Novel] = []
                        let list = UserDefaults.standard.stringArray(forKey: "novels")!
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

