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
    let chapters = CurrentValueSubject<[Chapter], Never>([])

    private let cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func fetch() {
        loadChapters { chapters in
            self.chapters.send(chapters)
        }
    }
}

