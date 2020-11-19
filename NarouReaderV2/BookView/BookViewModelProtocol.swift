import Combine

public enum BookCommand {
    case showSnackbar(String)
}

protocol BookViewModelProtocol {
    var command: PassthroughSubject<BookCommand, Never> { get }
    var books: CurrentValueSubject<[Book], Never> { get }
    
    func fetch()
}
