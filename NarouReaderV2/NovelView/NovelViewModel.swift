import Combine

final class NovelViewModel: NovelViewModelProtocol {
    var chapter: CurrentValueSubject<Chapter, Never>
    
    init(dependency: Dependency, chapter: Chapter) {
        self.chapter = CurrentValueSubject<Chapter, Never>(chapter)
        self.dependency = dependency
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

    let command = PassthroughSubject<NovelCommand, Never>()
    

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

   
    
}
