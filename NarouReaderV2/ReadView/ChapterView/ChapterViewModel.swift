import Combine
import UIKit
import Kanna

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
    var novelTitle = CurrentValueSubject<String, Never>("")
    var chapters = CurrentValueSubject<NovelsContents, Never>(NovelsContents())
    var ncode = ""

    private let cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, ncode: String) {
        self.dependency = dependency
        self.ncode = ncode
    }
}

