import Combine
import Foundation

final class BookViewModel: BookViewModelProtocol {
    
    
    struct Dependency {
        static var `default`: Dependency {
            Dependency(
            )
        }
    }

    let command = PassthroughSubject<BookCommand, Never>()
    let novels = CurrentValueSubject<[Novel], Never>([])

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func loadNovels(completion: @escaping () -> Void) {
        if UserDefaults.standard.stringArray(forKey: "novels") != [] {
            guard let novelList = UserDefaults.standard.stringArray(forKey: "novels")?.joined(separator: "-") else { return }
            let parameter = APILoginRequest(ncode: novelList)
            
            parameter.dispatch { (novels) in
                let list = UserDefaults.standard.stringArray(forKey: "novels")!
                var sortedNovels: [Novel] = []
                for novel in list {
                sortedNovels.append(contentsOf: novels.novels.filter{ $0.ncode == novel })
                }
                self.novels.send(sortedNovels)
                completion()
            } onFailure: { (errorResponse, error) in
                print(error)
            }
        }
    }
}
