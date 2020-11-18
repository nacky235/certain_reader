import Combine

final class BookViewModel: BookViewModelProtocol {
    struct Dependency {
        static var `default`: Dependency {
            Dependency(
            )
        }
    }

    // [Output]

    let command = PassthroughSubject<BookCommand, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
}
