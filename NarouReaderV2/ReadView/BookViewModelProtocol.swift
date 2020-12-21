import Combine

public enum BookCommand {
    case showSnackbar(String)
}

protocol BookViewModelProtocol {
    var command: PassthroughSubject<BookCommand, Never> { get }
    var novels: CurrentValueSubject<[Novel], Never> { get }
    
    func loadNovels(completion: @escaping () -> Void)
}
