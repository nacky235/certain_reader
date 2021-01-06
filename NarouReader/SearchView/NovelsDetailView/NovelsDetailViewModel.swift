import Combine

final class NovelsDetailViewModel: NovelsDetailViewModelProtocol {
    
    struct Dependency {

        static var `default`: Dependency {
            Dependency(
            )
        }
    }

    let command = PassthroughSubject<NovelsDetailCommand, Never>()
    let novel = CurrentValueSubject<Novel, Never>(Novel(title: "", ncode: "", writer: "", story: "", biggenre: 0, genre: 0))

    private var cancellables = Set<AnyCancellable>()
    private let dependency: Dependency

    init(dependency: Dependency, novel: Novel) {
        self.dependency = dependency
        self.novel.send(novel)
    }
}
