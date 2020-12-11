import Combine

public enum BookCommand {
    case showSnackbar(String)
}

protocol BookViewModelProtocol {
    var command: PassthroughSubject<BookCommand, Never> { get }
    var books: CurrentValueSubject<[Novel], Never> { get }
    
    func fetch()
}
