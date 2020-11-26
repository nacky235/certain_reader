import Combine
import UIKit

final class ChapterViewModel: ChapterViewModelProtocol {
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<ChapterCommand, Never>()
    var book = CurrentValueSubject<Book, Never>(Book())
    let chapters = CurrentValueSubject<[Chapter], Never>([])

    private let cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, book: Book) {
        self.dependency = dependency
        self.book.send(book)
    }

    func fetch() {
        loadChapters(bookId: self.book.value.id) { chapters in
            self.chapters.send(chapters)
        }
    }
}

