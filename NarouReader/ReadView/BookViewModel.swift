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

    let command = PassthroughSubject<BookCommand, Never>()
    let novels = CurrentValueSubject<[Novel], Never>([])

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func loadNovels() {
        self.getNovels { (novels) in
            self.novels.send(novels)
        }
    }
}
