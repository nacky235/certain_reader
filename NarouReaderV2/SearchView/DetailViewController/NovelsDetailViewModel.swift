import Combine

final class NovelsDetailViewModel: NovelsDetailViewModelProtocol {
    var novel: Novel
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<NovelsDetailCommand, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, novel: Novel) {
        self.dependency = dependency
        self.novel = novel
    }
}
