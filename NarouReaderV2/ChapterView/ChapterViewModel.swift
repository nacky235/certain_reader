import Combine
import UIKit

final class ChapterViewModel: ChapterViewModelProtocol {
    func transition(chapter: Chapter) {
        
    }
    
    func show(chapter: [Chapter]) {
        
    }
    
    
    var chapters = CurrentValueSubject<[Chapter], Never>([])
    
    func fetch() {
        loadChapters { chapters in
            self.chapters.send(chapters)
        }
        
    }
    
    
    
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

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
        loadChapters { chapters in
            self.chapters.send(chapters)
        }
    }
}

