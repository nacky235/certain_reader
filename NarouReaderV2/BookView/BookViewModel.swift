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
    let books = CurrentValueSubject<[Book], Never>([])

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func fetch() {
        loadBooks { books in
            self.books.send(books)
        }
    }
}
