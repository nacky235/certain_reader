import Combine
import UIKit

final class ChapterViewModel: ChapterViewModelProtocol {
    func show(chapter: [Chapter]) {
        
    }
    
    
    var chapters = CurrentValueSubject<[Chapter], Never>(loadChapters())
    
    func fetch() {
        
        
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
    }
}

