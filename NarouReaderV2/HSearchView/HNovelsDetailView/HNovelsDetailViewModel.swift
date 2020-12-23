import Combine

final class HNovelsDetailViewModel: HNovelsDetailViewModelProtocol {
    var hNovel: HNovel
    
    
    struct Dependency {
        // Add dependencies here.

        static var `default`: Dependency {
            Dependency(
                // Create a new aggregated dependency.
            )
        }
    }

    // Output

    let command = PassthroughSubject<HNovelsDetailCommand, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, hnovel: HNovel) {
        self.dependency = dependency
        self.hNovel = hnovel
    }
}
