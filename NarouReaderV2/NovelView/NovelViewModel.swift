import Combine

final class NovelViewModel: NovelViewModelProtocol {
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
//    let chapter: CurrentValueSubject<Chapter, Never> = (Chapter())
    let content: CurrentValueSubject<[String], Never>

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency
   
//    init(dependency: Dependency, chapter: Chapter) {
//        self.chapter = CurrentValueSubject<Chapter, Never>(chapter)
//        self.dependency = dependency
//    }
    
    init(content: [String]) {
        self.dependency = .default
        self.content = CurrentValueSubject<[String], Never>(content)
    }
}
